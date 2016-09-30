//
//  TestViewController.swift
//  SwiftFrameworkDemo
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SwiftFramework

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.className()) data:\(self.controllerData)")
        let data:Dictionary<String,AnyObject> = ["backFromController":self.className() as AnyObject]
        close(data: data)
    }
}

extension TestViewController:SwiftControllerInitProtocol {
    
    func initView() {
        self.view.backgroundColor = UIColor.black
        
    }
}


extension TestViewController:SwiftRouteProtocol {
    static func prepareController() -> UIViewController? {
        print("<SwiftRouteProtocol> prepareController: TestViewController")
        if let ctl = UIViewController.prepareStoryboardController(storyboardName: "Main", controllerIdentifier: "TestViewController") {
            let naviCtl = UINavigationController()
            naviCtl.viewControllers = [ctl]
            
            return naviCtl
        }
        return nil
    }
    
    func showController(controllerIdentifier:String, present:Bool, data:Dictionary<String,AnyObject>?) {
        show(controllerIdentifier: controllerIdentifier, present: present, transitioning:nil, data:data)
    }
    
    func closeController(data: Dictionary<String, AnyObject>) {
        close(data: data)
    }
}




