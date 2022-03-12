//
//  RectView.swift
//  MemeMe
//
//  Created by Gökce Hatipoglu Majernik on 3/11/22.
//

import Foundation
import UIKit

class RectView: UIView {
    
    var id: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("could not get graphics context")
            return
        }

        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2)
        context.stroke(rect.insetBy(dx: 10, dy: 10))
    }
}
