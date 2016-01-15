//
//  ViewController.swift
//  MorseTorch
//
//  Created by YehYungCheng on 2016/1/12.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(type: .Custom)
        button.frame = UIScreen.mainScreen().bounds
        button.setTitle("🔦", forState: UIControlState.Normal)
        button.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 100)
        button.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttonPressed() {
        FlashingTorch(text: "SOS").start()
    }
}

