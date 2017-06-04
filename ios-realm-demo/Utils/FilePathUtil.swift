//
//  FilePathUtil.swift
//  ios-realm-demo
//
//  Created by OkuderaYuki on 2017/06/04.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import Foundation

final class FilePathUtil {
    
    /// applicationSupportDirectoryのPATHを取得する
    static let applicationSupportDir = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    
    /// realmのPATHを取得する
    static let realmPath = FilePathUtil.applicationSupportDir.appendingPathComponent("sample.realm")
    
    /// applicationSupportDirectoryが無ければ生成する
    static func createApplicationSupport() {
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: FilePathUtil.applicationSupportDir) {
            return
        }
        
        do {
            try fileManager.createDirectory(atPath: FilePathUtil.applicationSupportDir,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
        } catch (let error) {
            print("\(error.localizedDescription)")
            fatalError("applicationSupportDirectory作成失敗")
        }
    }
}
