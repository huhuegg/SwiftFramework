//
//  ViewController.swift
//  SwiftFrameworkDemo
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SwiftFramework

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi(hidden: true, hidesBackButton: false, title: "ViewController")
        
        print("\n>>>>\n\(self.className()) data:\(self.controllerData)\n<<<<\n")
    }
    
    @IBAction func toTableVCButtonClicked(_ sender: AnyObject) {
        showController(controllerIdentifier: "TestTableViewController", present: false, data: nil)
    }
}

extension ViewController:SwiftControllerInitProtocol {

    func initView() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
    }
    
}

extension ViewController:SwiftRouteProtocol {
    
    static func prepareController() -> UIViewController? {
        print("<SwiftRouteProtocol> prepareController: ViewController")
        if let ctl = UIViewController.prepareStoryboardController(storyboardName: UIStoryboard.Storyboard.Main.rawValue, controllerIdentifier: UIStoryboard.StoryboardController.ViewController.rawValue) {
            
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
        
    }
}

