//
//  ViewControllerExtension.swift
//  SwiftFramework
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import Foundation

struct SwiftControllerData {
    var isPresent:Bool!
    
}

public extension UIViewController {
    public var controllerData:Dictionary<String,AnyObject>? {
        get {
            return SwiftRouter.instance.loadControllerData(controller: self)
        }
        
        set {
            //新赋的值默认为newValue
            SwiftRouter.instance.saveControllerData(controller: self, data: newValue)
        }
    }
    
    public func className() ->String {
        return String(describing: self.classForCoder)
    }
    
    public static func prepareStoryboardController(storyboardName:String, controllerIdentifier:String)->UIViewController? {

        let bundle = Bundle.main
        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        sb.instantiateInitialViewController()

        guard let controller = sb.instantiateViewController(withIdentifier: controllerIdentifier) as? UIViewController else {
            print("❌--- prepareController failed(storyboardName:\(storyboardName) controllerIdentifier:\(controllerIdentifier))")
            return nil
        }
        
        SwiftRouter.instance.prepareInitControllerData(controller: controller)
        
        print("✅--- prepareController succeed(controllerIdentifier:\(controllerIdentifier))")
        return controller

    }
    
    public func show(controllerIdentifier:String, present:Bool, transitioning: UIViewControllerAnimatedTransitioning?, data:Dictionary<String,AnyObject>?) {
        
        let toControllerInfo:ToControllerInfo = ToControllerInfo(controllerIdentifier: controllerIdentifier)
        let showControllerInfo = ShowControllerInfo(fromController: self, toControllerInfo: toControllerInfo, showWithPresent: present, transitioning: transitioning, data: data)

        SwiftRouter.instance.showController(info: showControllerInfo) { (status) in
            
        }
    }
    
    public func close(data:Dictionary<String,AnyObject>?) {
        SwiftRouter.instance.closeController(fromController: self, animated: true, withData: data) { (status) in
            
        }
    }

}

public extension UIViewController {
    func setupTabBar(hidden:Bool) {
        self.tabBarController?.tabBar.isHidden = hidden
        self.tabBarController?.setupTabBar(hidden: hidden)
    }
    
    //hidden ＝＝ true时，隐藏Navi
    //hidesBackButton == true时，屏蔽返回按钮，并屏蔽返回手势
    func setupNavi(hidden:Bool, hidesBackButton:Bool, title:String) {
        self.navigationController?.navigationBar.isHidden = hidden
        self.navigationItem.hidesBackButton = hidesBackButton
        self.navigationItem.title = title
        self.navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    
}



