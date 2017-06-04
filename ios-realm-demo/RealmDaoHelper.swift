//
//  RealmDaoHelper.swift
//  ios-realm-demo
//
//  Created by Kushida　Eiji on 2017/03/11.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import RealmSwift

final class RealmDaoHelper <T: RealmSwift.Object> {
    let realm: Realm
    
    init() {
        do {
            try realm = Realm(configuration: RealmDaoHelper.makeRealmConfig())
        } catch (let error) {
            print(error.localizedDescription)
            fatalError("RealmDaoHelper initialize error.")
        }
    }
    
    // MARK: - Configuration
    
    /**
     * Configurationを生成
     */
    static func makeRealmConfig() -> Realm.Configuration {
        var config = Realm.Configuration()
        
        FileUtil.createApplicationSupport()
        config.fileURL = RealmDaoHelper.realmFileURL(urlString: FileUtil.realmPath)
        config.encryptionKey = realmEncryptionKey()
        return config
    }
    
    /**
     * Realmファイルの保存先を設定
     */
    static func realmFileURL(urlString: String) -> URL? {
        print("realmPath: \(urlString)")
        return URL(fileURLWithPath: urlString)
    }
    
    /**
     * Realm暗号化キーを設定
     */
    static func realmEncryptionKey() -> Data? {
        
        // 64byte encryption key
        let keyString = "BKvr8yHkRxGeeBMoqezWVOitFXtNhecBwqiVuL3phb5iR0eb0KPthLetHzR6WX8G"
        let keyData = keyString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let keyData = keyData {
            print("realmKey: \(keyData.map { String(format: "%.2hhx", $0) }.joined())")
        }
        
        return keyData
    }
    
    // MARK: - newId
    
    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        
        let realm = try! Realm(configuration: RealmDaoHelper.makeRealmConfig())
        return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
    }
    
    // MARK: - find
    
    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }
    
    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }
    
    // MARK: - add
    
    /**
     * レコード追加を取得
     */
    func add(d :T) {
        do {
            try realm.write {
                realm.add(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    // MARK: - update
    
    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    func update(d: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(d, update: true)
            }
            return true
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    // MARK: - delete
    
    /**
     * レコード削除
     */
    func delete(d: T) {
        do {
            try realm.write {
                realm.delete(d)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
}

