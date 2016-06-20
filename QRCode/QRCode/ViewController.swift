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
        
        let button = UIButton(frame: CGRect(x: (UIScreen.main().bounds.size.width-100) * 0.5, y: (UIScreen.main().bounds.size.height-30) * 0.5, width: 100, height: 30))
        button.setTitle("扫一扫", for: UIControlState())
        button.setTitleColor(UIColor.blue(), for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
    }
    
    func buttonAction(_ sender : AnyObject){
        print("扫一扫")
        let  scanner = ScannerViewController()
        self.navigationController?.pushViewController(scanner, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

