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
    var previousLocation = CGPoint.zero
    var rotateLine = CAShapeLayer()
    
    
    override func didMoveToSuperview() {
        let resizeFillColor = UIColor.cyan
        let resizeStrokeColor = UIColor.black
        let rotateFillColor = UIColor.orange
        let rotateStrokeColor = UIColor.black
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
        
        
        var pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        topLeft.addGestureRecognizer(pan)
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        topRight.addGestureRecognizer(pan)
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        bottomLeft.addGestureRecognizer(pan)
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        bottomRight.addGestureRecognizer(pan)
        pan = UIPanGestureRecognizer(target: self, action: #selector(handleRotate))
        rotateHandle.addGestureRecognizer(pan)
        pan = UIPanGestureRecognizer(target: self, action: #selector(handleMove))
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
    
    @objc func handleMove(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview!)
        
        var center = self.center
        center.x += translation.x
        center.y += translation.y
        self.center = center
        
        gesture.setTranslation(CGPoint.zero, in: self.superview!)
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
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        rotateLine.path = linePath.cgPath
        rotateLine.fillColor = nil
        rotateLine.strokeColor = UIColor.orange.cgColor
        rotateLine.lineWidth = 2.0
        rotateLine.opacity = 1.0
    }
    
    @objc func handleRotate(gesture:UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            previousLocation = rotateHandle.center
            self.drawRotateLine(fromPoint: CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2), toPoint:CGPoint(x: self.bounds.size.width + diameter, y: self.bounds.size.height/2))
        case .ended:
            self.rotateLine.opacity = 0.0
        default:()
        }
        let location = gesture.location(in: self.superview!)
        let angle = angleBetweenPoints(startPoint: previousLocation, endPoint: location)
        self.transform = self.transform.rotated(by: angle)
        previousLocation = location
        self.updateDragHandles()
    }
    
    @objc func handlePan(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        switch gesture.view! {
        case topLeft:
            if gesture.state == .began {
                self.setAnchorPoint(anchorPoint: CGPoint(x: 1, y: 1))
            }
            self.bounds.size.width -= translation.x
            self.bounds.size.height -= translation.y
        case topRight:
            if gesture.state == .began {
                self.setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 1))
            }
            self.bounds.size.width += translation.x
            self.bounds.size.height -= translation.y
            
        case bottomLeft:
            if gesture.state == .began {
                self.setAnchorPoint(anchorPoint: CGPoint(x: 1, y: 0))
            }
            self.bounds.size.width -= translation.x
            self.bounds.size.height += translation.y
        case bottomRight:
            if gesture.state == .began {
                self.setAnchorPoint(anchorPoint: CGPoint.zero)
            }
            self.bounds.size.width += translation.x
            self.bounds.size.height += translation.y
        default:()
        }
        
        gesture.setTranslation(CGPoint.zero, in: self)
        updateDragHandles()
        if gesture.state == .ended {
            self.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))
        }
    }
}
