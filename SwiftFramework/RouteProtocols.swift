//
//  RouteProtocols.swift
//  SwiftFramework
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import Foundation

public protocol SwiftRouteProtocol {
    
    static func prepareController() -> UIViewController?

    func showController(controllerIdentifier:String, present:Bool, data:Dictionary<String,AnyObject>?)
    
    func closeController(data:Dictionary<String,AnyObject>)
}




