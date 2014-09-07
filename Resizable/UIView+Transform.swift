//
//  UIView+Transform.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

//Credits:
//Erica Sadun: http://www.informit.com/articles/article.aspx?p=1951182
//Brad Larson / Magnus: http://stackoverflow.com/a/5666430/359578

import Foundation
import UIKit

extension UIView {
  
  func offsetPointToParentCoordinates(point: CGPoint) -> CGPoint {
    return CGPointMake(point.x + self.center.x, point.y + self.center.y)
  }
  
  func pointInViewCenterTerms(point:CGPoint) -> CGPoint {
    return CGPointMake(point.x - self.center.x, point.y - self.center.y)
  }
  
  func pointInTransformedView(point: CGPoint) -> CGPoint {
    let offsetItem = self.pointInViewCenterTerms(point)
    let updatedItem = CGPointApplyAffineTransform(offsetItem, self.transform)
    let finalItem = self.offsetPointToParentCoordinates(updatedItem)
    return finalItem
  }
  
  func originalFrame() -> CGRect {
    let currentTransform = self.transform
    self.transform = CGAffineTransformIdentity
    let originalFrame = self.frame
    self.transform = currentTransform
    return originalFrame
  }
  
  //These four methods return the positions of view elements
  //with respect to the current transformation
  
  func transformedTopLeft() -> CGPoint {
    let frame = self.originalFrame()
    let point = frame.origin
    return self.pointInTransformedView(point)
  }
  
  func transformedTopRight() -> CGPoint {
    let frame = self.originalFrame()
    var point = frame.origin
    point.x += frame.size.width
    return self.pointInTransformedView(point)
  }
  
  func transformedBottomRight() -> CGPoint {
    let frame = self.originalFrame()
    var point = frame.origin
    point.x += frame.size.width
    point.y += frame.size.height
    return self.pointInTransformedView(point)
  }
  
  func transformedBottomLeft() -> CGPoint {
    let frame = self.originalFrame()
    var point = frame.origin
    point.y += frame.size.height
    return self.pointInTransformedView(point)
  }
  
  func transformedRotateHandle() -> CGPoint {
    let frame = self.originalFrame()
    var point = frame.origin
    point.x += frame.size.width + 40
    point.y += frame.size.height / 2
    return self.pointInTransformedView(point)
  }
  
  func setAnchorPoint(anchorPoint:CGPoint) {
    var newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y)
    var oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y)
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform)
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform)
    
    var position = self.layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x
    position.y -= oldPoint.y
    position.y += newPoint.y
    
    self.layer.position = position
    self.layer.anchorPoint = anchorPoint
  }

}