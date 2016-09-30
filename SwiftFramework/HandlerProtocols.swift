//
//  HandlerProtocols.swift
//  SwiftFramework
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import Foundation

public protocol HandlerInitDataProtocol {
    associatedtype DataType
    var data: [DataType] { get set }
    
}
