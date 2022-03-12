//
//  CropView.swift
//  MemeMe
//
//  Created by Gökce Hatipoglu Majernik on 3/11/22.
//

import Foundation
import UIKit

class CropView: UIView {
    
    let cornerSize = 50.0
    var outerRect: RectView!
    var leftTopCorner: RectView!
    var leftBottomCorner: RectView!
    var rightTopCorner: RectView!
    var rightBottomCorner: RectView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func drawCropper() {
        outerRect = drawRectangle()
        leftTopCorner = drawCorner(x: bounds.origin.x, y: bounds.origin.y)
        leftBottomCorner = drawCorner(x: bounds.origin.x, y: bounds.height - cornerSize)
        rightTopCorner = drawCorner(x: bounds.width - cornerSize, y: bounds.origin.y)
        rightBottomCorner = drawCorner(x: bounds.width - cornerSize, y: bounds.height - cornerSize)
        
        leftTopCorner.id = "leftTop"
        leftTopCorner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cornerDragged)))
        
        leftBottomCorner.id = "leftBottom"
        leftBottomCorner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cornerDragged)))
        
        rightTopCorner.id = "rightTop"
        rightTopCorner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cornerDragged)))
        
        rightBottomCorner.id = "rightBottom"
        rightBottomCorner.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cornerDragged)))
        
        addSubview(outerRect)
        addSubview(leftTopCorner)
        addSubview(rightTopCorner)
        addSubview(leftBottomCorner)
        addSubview(rightBottomCorner)
    }
    
    func redraw() {
        outerRect?.removeFromSuperview()
        leftTopCorner?.removeFromSuperview()
        rightTopCorner?.removeFromSuperview()
        leftBottomCorner?.removeFromSuperview()
        rightBottomCorner?.removeFromSuperview()
        
        drawCropper()
    }
    
    func drawRectangle() -> RectView {
        let rect = RectView(frame: bounds)
        rect.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        
        return rect
    }
    
    func drawCorner(x: CGFloat, y: CGFloat) -> RectView {
        let corner = RectView(frame: CGRect(x: x, y: y, width: cornerSize, height: cornerSize))
        corner.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        
        return corner
    }
    
    @objc func cornerDragged(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let corner = gesture.view as! RectView
        
        corner.center.x = location.x
        corner.center.y = location.y
        
        switch(corner.id) {
        case "leftTop":
            leftBottomCorner.center.x = location.x
            rightTopCorner.center.y = location.y
            
            outerRect.frame.size.width = abs(corner.frame.origin.x - rightTopCorner.frame.origin.x) + cornerSize
            outerRect.frame.size.height = abs(corner.frame.origin.y - leftBottomCorner.frame.origin.y) + cornerSize
            outerRect.frame.origin.x = corner.frame.origin.x
            outerRect.frame.origin.y = corner.frame.origin.y
            
            break;
        case "leftBottom":
            leftTopCorner.center.x = location.x
            rightBottomCorner.center.y = location.y
            
            outerRect.frame.size.width = abs(corner.frame.origin.x - rightBottomCorner.frame.origin.x) + cornerSize
            outerRect.frame.size.height = abs(corner.frame.origin.y - leftTopCorner.frame.origin.y) + cornerSize
            outerRect.frame.origin.x = corner.frame.origin.x
            break;
        case "rightTop":
            leftTopCorner.center.y = location.y
            rightBottomCorner.center.x = location.x
            
            outerRect.frame.size.width = abs(corner.frame.origin.x - leftTopCorner.frame.origin.x) + cornerSize
            outerRect.frame.size.height = abs(corner.frame.origin.y - rightBottomCorner.frame.origin.y) + cornerSize
            outerRect.frame.origin.y = corner.frame.origin.y
            break;
        case "rightBottom":
            rightTopCorner.center.x = location.x
            leftBottomCorner.center.y = location.y
            
            outerRect.frame.size.width = abs(corner.frame.origin.x - leftBottomCorner.frame.origin.x) + cornerSize
            outerRect.frame.size.height = abs(corner.frame.origin.y - rightTopCorner.frame.origin.y) + cornerSize
            break;
        default:
            break;
        }
    }
}
