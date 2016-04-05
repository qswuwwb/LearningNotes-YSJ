//
//  ViewController.swift
//  collection view
//
//  Created by ysj on 16/4/2.
//  Copyright © 2016年 newbieYin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.sourceViewController
    }

}

