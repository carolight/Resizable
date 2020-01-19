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
    
    var fillColor = UIColor.darkGray
    var strokeColor = UIColor.lightGray
    var strokeWidth:CGFloat = 2.0
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Use init(fillColor:, strokeColor:)")
    }
    
    init(fillColor:UIColor, strokeColor:UIColor, strokeWidth width:CGFloat = 2.0) {
        super.init(frame:CGRect(x: 0, y: 0, width: diameter, height: diameter))
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = width
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        var handlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 10 + strokeWidth, dy: 10 + strokeWidth))
        fillColor.setFill()
        handlePath.fill()
        strokeColor.setStroke()
        handlePath.lineWidth = strokeWidth
        handlePath.stroke()
    }
}
