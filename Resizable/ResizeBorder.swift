//
//  ResizeBorder.swift
//  Resizable
//
//  Created by Adil Soomro on 7/02/2017.
//  Copyright (c) 2017 BooleanBites Ltd. All rights reserved.
//



import UIKit

let dash1: CGFloat = 2.0
let dash2: CGFloat = 4.0

let lineWidth: CGFloat = 2.5

let dash:[CGFloat] = [dash1, dash2]

class ResizeBorder: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect)
    {
        
        
        let context = UIGraphicsGetCurrentContext();
        context!.saveGState();
        
        context!.setLineWidth(lineWidth);
        
        
        context?.setLineDash(phase: 0.0, lengths: dash)
        
        context!.setStrokeColor(UIColor.black.cgColor);
        context!.addRect(self.bounds);
        context!.strokePath();
        
        context!.restoreGState();
    }
}
