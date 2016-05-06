//
//  ViewController.swift
//  QRCode
//
//  Created by Erwin on 16/5/5.
//  Copyright © 2016年 Erwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        
        let button = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width-100) * 0.5, (UIScreen.mainScreen().bounds.size.height-30) * 0.5, 100, 30))
        button.setTitle("扫一扫", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    func buttonAction(sender : AnyObject){
        print("扫一扫")
        let  scanner = ScannerViewController()
        self.navigationController?.pushViewController(scanner, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

