//
//  ResizableView.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

import UIKit

class ResizableView: UIView {

  var topLeft:DragHandle!
  var topRight:DragHandle!
  var bottomLeft:DragHandle!
  var bottomRight:DragHandle!
  var rotateHandle:DragHandle!
  var previousLocation = CGPointZero
  var rotateLine = CAShapeLayer()

  
  override func didMoveToSuperview() {
    let resizeFillColor = UIColor.cyanColor()
    let resizeStrokeColor = UIColor.blackColor()
    let rotateFillColor = UIColor.orangeColor()
    let rotateStrokeColor = UIColor.blackColor()
    topLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    topRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    rotateHandle = DragHandle(fillColor:rotateFillColor, strokeColor:rotateStrokeColor)
    
    rotateLine.opacity = 0.0
    rotateLine.lineDashPattern = [3,2]
    
    superview?.addSubview(topLeft)
    superview?.addSubview(topRight)
    superview?.addSubview(bottomLeft)
    superview?.addSubview(bottomRight)
    superview?.addSubview(rotateHandle)
    self.layer.addSublayer(rotateLine)
  
    
    var pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
    topLeft.addGestureRecognizer(pan)
    pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
    topRight.addGestureRecognizer(pan)
    pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
    bottomLeft.addGestureRecognizer(pan)
    pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
    bottomRight.addGestureRecognizer(pan)
    pan = UIPanGestureRecognizer(target: self, action: "handleRotate:")
    rotateHandle.addGestureRecognizer(pan)
    pan = UIPanGestureRecognizer(target: self, action: "handleMove:")
    self.addGestureRecognizer(pan)
    
    self.updateDragHandles()
  }

  func updateDragHandles() {
    topLeft.center = self.transformedTopLeft()
    topRight.center = self.transformedTopRight()
    bottomLeft.center = self.transformedBottomLeft()
    bottomRight.center = self.transformedBottomRight()
    rotateHandle.center = self.transformedRotateHandle()
  }

  //MARK: - Gesture Methods
  
  func handleMove(gesture:UIPanGestureRecognizer) {
    let translation = gesture.translationInView(self.superview!)
    
    var center = self.center
    center.x += translation.x
    center.y += translation.y
    self.center = center

    gesture.setTranslation(CGPointZero, inView: self.superview!)
    updateDragHandles()
  }
  
  func angleBetweenPoints(startPoint:CGPoint, endPoint:CGPoint)  -> CGFloat {
    let a = startPoint.x - self.center.x
    let b = startPoint.y - self.center.y
    let c = endPoint.x - self.center.x
    let d = endPoint.y - self.center.y
    let atanA = atan2(a, b)
    let atanB = atan2(c, d)
    return atanA - atanB
    
  }

  func drawRotateLine(fromPoint:CGPoint, toPoint:CGPoint) {
    var linePath = UIBezierPath()
    linePath.moveToPoint(fromPoint)
    linePath.addLineToPoint(toPoint)
    rotateLine.path = linePath.CGPath
    rotateLine.fillColor = nil
    rotateLine.strokeColor = UIColor.orangeColor().CGColor
    rotateLine.lineWidth = 2.0
    rotateLine.opacity = 1.0
  }
  
  func handleRotate(gesture:UIPanGestureRecognizer) {
    switch gesture.state {
    case .Began:
      previousLocation = rotateHandle.center
      self.drawRotateLine(CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), toPoint:CGPointMake(self.bounds.size.width + diameter, self.bounds.size.height/2))
    case .Ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.locationInView(self.superview!)
    let angle = angleBetweenPoints(previousLocation, endPoint: location)
    self.transform = CGAffineTransformRotate(self.transform, angle)
    previousLocation = location
    self.updateDragHandles()
  }
  
  func handlePan(gesture:UIPanGestureRecognizer) {
    var translation = gesture.translationInView(self)
    switch gesture.view! {
    case topLeft:
      if gesture.state == .Began {
        self.setAnchorPoint(CGPointMake(1, 1))
      }
      self.bounds.size.width -= translation.x
      self.bounds.size.height -= translation.y
    case topRight:
      if gesture.state == .Began {
        self.setAnchorPoint(CGPointMake(0, 1))
      }
      self.bounds.size.width += translation.x
      self.bounds.size.height -= translation.y

    case bottomLeft:
      if gesture.state == .Began {
        self.setAnchorPoint(CGPointMake(1, 0))
      }
      self.bounds.size.width -= translation.x
      self.bounds.size.height += translation.y
    case bottomRight:
      if gesture.state == .Began {
        self.setAnchorPoint(CGPointZero)
      }
      self.bounds.size.width += translation.x
      self.bounds.size.height += translation.y
    default:()
    }
    
    gesture.setTranslation(CGPointZero, inView: self)
    updateDragHandles()
    if gesture.state == .Ended {
      self.setAnchorPoint(CGPointMake(0.5, 0.5))
    }
  }
}
