//
//  String+Path.swift
//  ios-realm-demo
//
//  Created by OkuderaYuki on 2017/06/04.
//  Copyright © 2017年 Kushida　Eiji. All rights reserved.
//

import UIKit

import Foundation

public extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
}
