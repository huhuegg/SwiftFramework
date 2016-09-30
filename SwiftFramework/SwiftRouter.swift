//
//  SwiftRouter.swift
//  SwiftFramework
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import Foundation

public struct ToControllerInfo {
    var controllerIdentifier:String = ""
    var controller:UIViewController?
    
    public init(controllerIdentifier:String) {
        self.controllerIdentifier = controllerIdentifier
    }
    
    public init(controller:UIViewController) {
        self.controllerIdentifier = ""
        self.controller = controller
    }
}

public struct ShowControllerInfo {
    
    var fromController:UIViewController!
    var toControllerInfo:ToControllerInfo!
    
    //Controller切换类型
    var showWithPresent:Bool!
    
    //Controller切换动画
    var transitioning:UIViewControllerAnimatedTransitioning?
    
    //传递数据
    var data:Dictionary<String,AnyObject>?
    
    public init(fromController:UIViewController, toControllerInfo:ToControllerInfo, showWithPresent:Bool, transitioning:UIViewControllerAnimatedTransitioning?, data:Dictionary<String,AnyObject>?) {
        self.fromController = fromController
        self.toControllerInfo = toControllerInfo
        self.showWithPresent = showWithPresent
        self.transitioning = transitioning
        self.data = data
    }
    
}

public class SwiftRouter {
    private static let swiftRouterInstance = SwiftRouter()
    
    public static let instance:SwiftRouter = {
        return swiftRouterInstance
    }()
    
    
    var controllersData:Dictionary<String,Dictionary<String,AnyObject>?>!
    
    init() {
        controllersData = Dictionary()
    }

    //Router
    public func showController(info:ShowControllerInfo, completed:@escaping (_ status:Bool)->()) {
        var fromController:UIViewController = info.fromController
        var toController:UIViewController!
        
        if info.toControllerInfo.controller == nil {
            let toControllerIdentifier = info.toControllerInfo.controllerIdentifier
            
            if toControllerIdentifier == "" {
                print("##SwiftRouter## showController info error(controllerIdentifier:\(toControllerIdentifier))")
                completed(false)
                return
            }
            
            guard let toControllerClass = classFromString(controllerIdentifier: toControllerIdentifier) as? UIViewController.Type else {
                print("##SwiftRouter## toControllerClass is not UIViewController")
                completed(false)
                return
            }
            
            
            
            guard let toCtl = toControllerClass.prepareStoryboardController(storyboardName: "Main", controllerIdentifier: toControllerIdentifier) else {
                print("##SwiftRouter## prepareStoryboardController failed")
                completed(false)
                return
            }
            toController = toCtl
            
            
        } else {
            toController = info.toControllerInfo.controller
        }
        
        prepareShowControllerData(from: fromController, to: toController, isPresent: info.showWithPresent, withData: info.data)
        
        print("🚀##SwiftRouter## showController: \(fromController.className()) -> \(toController.className()) isPresent:\(info.showWithPresent!)")
        
        if info.showWithPresent == true {
            fromController.present(toController, animated: true, completion: { 
                completed(true)
            })
        } else {
            guard let naviCtl = fromController.navigationController else {
                print("##SwiftRouter## Can't find naviCtl, Push failed!")
                completed(false)
                return
            }
            naviCtl.pushViewController(toController, animated: true)
            completed(true)
        }
    }
    
    public func closeController(fromController:UIViewController,animated:Bool, withData:Dictionary<String,AnyObject>?, completed:@escaping (_ status:Bool)->()) {
        guard let controllerData = fromController.controllerData else {
            print("##SwiftRouter## closeController: \(fromController.className()) controllerData not found")
            completed(false)
            return
        }
        guard let isPresented = controllerData["isPresented"] as? Bool else {
            print("##SwiftRouter## closeController: \(fromController.className()) controllerData[isPresent] not found")
            completed(false)
            return
        }
        
        guard let toControllerAddr = controllerData["fromControllerAddr"] as? String else {
            print("##SwiftRouter## closeController: \(fromController.className()) controllerData[fromControllerAddr] not found")
            completed(false)
            return
        }
        
        guard var d = SwiftRouter.instance.loadControllerData(controllerAddress: toControllerAddr) else {
            print("##SwiftRouter## closeController: \(fromController.className()) load backController's  ControllerData failed")
            completed(false)
            return
        }
        
        prepareCloseControllerData(from: fromController, toControllerAddr: toControllerAddr, backData: withData)
        
        let toControllerData = loadControllerData(controllerAddress: toControllerAddr)
        if let toControllerClassName = toControllerData?["className"] as? String {
            print("🚀##SwiftRouter## closeController: \(fromController.className()) -> \(toControllerClassName) isDismiss:\(isPresented)")
        } else {
            print("🚀##SwiftRouter## closeController: \(fromController.className()) isDismiss:\(isPresented)")
        }
        
        
        if isPresented {
            fromController.dismiss(animated: animated, completion: {
                self.destroyControllerData(controller: fromController)
            })
        } else {
            guard let naviCtl = fromController.navigationController else {
                print("##SwiftRouter## closeController: \(fromController.className()) not found navigationController, can't pop")
                completed(false)
                return
            }
            naviCtl.popViewController(animated: animated)
            destroyControllerData(controller: fromController)
            completed(true)
        }
    }

    
    //MARK: - Data
    public func prepareInitControllerData(controller:UIViewController) {
        print("💾##SwiftRouter## prepareInitControllerData for \(controller.className())")
        var data:Dictionary<String,AnyObject> = Dictionary()
        
        let d:Dictionary<String,AnyObject> = Dictionary()
        data["className"] = controller.className() as AnyObject
        data["fromControllerAddr"] = "" as AnyObject
        data["isPresented"] = false as AnyObject
        data["isFromBack"] = false as AnyObject
        data["data"] = d as AnyObject
        
        controller.controllerData = data
    }
    
    public func prepareShowControllerData(from:UIViewController, to:UIViewController, isPresent:Bool, withData:Dictionary<String,AnyObject>?) {
        print("💾##SwiftRouter## prepareShowControllerData for \(to.className()) ")
        var data:Dictionary<String,AnyObject> = Dictionary()
        data["fromControllerAddr"] = address(o: from) as AnyObject?
        data["isPresented"] = isPresent as AnyObject?
        data["isFromBack"] = false as AnyObject?
        data["toData"] = withData as AnyObject?
        
        let backData:Dictionary<String,AnyObject> = Dictionary()
        data["backData"] = backData as AnyObject?
        
        to.controllerData = data
    }
    
    public func prepareCloseControllerData(from:UIViewController, toControllerAddr:String, backData:Dictionary<String,AnyObject>?) {
        //
        
        var data = loadControllerData(controllerAddress: toControllerAddr)
        if let toControllerClassName = data?["className"] as? String {
            print("💾##SwiftRouter## prepareCloseControllerData for \(toControllerClassName) ")
        } else {
            print("💾##SwiftRouter## prepareCloseControllerData for \(toControllerAddr) ")
        }
        
        data?["isFromBack"] = true as AnyObject?
        data?["backData"] = backData as AnyObject?
        
        saveControllerData(controllerAddress: toControllerAddr, data: data)
    }
    
    
    public func loadControllerData(controller:UIViewController) -> Dictionary<String,AnyObject>? {
        //print("Address:   \(controller.className()) -- \(address(o: controller))")
        let key = address(o: controller)
        if let dict = controllersData[key] {
            //print("loadControllerData:\(controller.className()) data:\(dict)")
            return dict
        }
        //print("loadControllerData:\(controller.className()) data: nil")
        return nil
    }
    
    public func loadControllerData(controllerAddress:String) -> Dictionary<String,AnyObject>? {
        if let dict = controllersData[controllerAddress] {
            //print("loadControllerData:\(controller.className()) data:\(dict)")
            return dict
        }
        //print("loadControllerData:\(controller.className()) data: nil")
        return nil
    }
    
    public func saveControllerData(controller:UIViewController, data:Dictionary<String,AnyObject>?) {
        //print("saveControllerData:\(controller.className()) addr:\(address(o: controller)) data:\(data)")
        let key = address(o: controller)
        controllersData[key] = data
    }
    
    public func saveControllerData(controllerAddress:String, data:Dictionary<String,AnyObject>?) {
        //print("saveControllerData addr:\(controllerAddress) data:\(data)")

        controllersData[controllerAddress] = data
    }
    
    public func destroyControllerData(controller:UIViewController) {
        let key = address(o: controller)
        controllersData.removeValue(forKey: key)
    }
}

extension SwiftRouter {
    fileprivate func classFromString(controllerIdentifier:String)->AnyClass {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let className = "_TtC\(appName.characters.count)\(appName)\(controllerIdentifier.characters.count)\(controllerIdentifier)"
        
        let c = NSClassFromString(className) as! UIViewController.Type
        return c.classForCoder()
    }
    
    public func address<T: AnyObject>(o: T) -> String {
        return String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
    }
}
