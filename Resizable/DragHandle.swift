//
//  DragHandle.swift
//  Resizable
//
//  Created by Caroline on 7/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

let diameter:CGFloat = 40

import UIKit

class DragHandle: UIView {

  var fillColor = UIColor.darkGrayColor()
  var strokeColor = UIColor.lightGrayColor()
  var strokeWidth:CGFloat = 2.0
  
  required init(coder aDecoder: NSCoder) {
    fatalError("Use init(fillColor:, strokeColor:)")
  }
  
  init(fillColor:UIColor, strokeColor:UIColor, strokeWidth width:CGFloat = 2.0) {
    super.init(frame:CGRectMake(0, 0, diameter, diameter))
    self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.strokeWidth = width
    self.backgroundColor = UIColor.clearColor()
  }
  
    override func drawRect(rect: CGRect)
    {
      super.drawRect(rect)
      var handlePath = UIBezierPath(ovalInRect: CGRectInset(rect, 10 + strokeWidth, 10 + strokeWidth))
      fillColor.setFill()
      handlePath.fill()
      strokeColor.setStroke()
      handlePath.lineWidth = strokeWidth
      handlePath.stroke()
    }
}
