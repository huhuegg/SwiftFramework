//
//  TestNaviTableViewController.swift
//  SwiftFrameworkDemo
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SwiftFramework

class TestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi(hidden: false, hidesBackButton: false, title: "TestTableVC")
    }
}

extension TestTableViewController:SwiftControllerInitProtocol {
    func initView() {
        self.view.backgroundColor = UIColor.black
    }
}
