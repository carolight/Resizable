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
    let resizableView = ResizableView(frame: CGRect(x: 60, y: 100, width: 200, height: 200))
    resizableView.backgroundColor = UIColor.lightGray
    resizableView.center = CGPoint(x: 160, y: 200)
    self.view.addSubview(resizableView)
  }
}

