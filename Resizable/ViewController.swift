//
//  ViewController.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    var resizableView = ResizableView(frame: CGRectMake(60, 100, 200, 200))
    resizableView.backgroundColor = UIColor.purpleColor()
    resizableView.transform = CGAffineTransformMakeRotation(0.3)
    resizableView.center = CGPointMake(160, 200)
    self.view.addSubview(resizableView)
  }
}

