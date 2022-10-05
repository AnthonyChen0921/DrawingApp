//
//  Circle.swift
//  AnthonyChen-Lab3
//
//  Created by Anthony C on 10/1/22.
//

import UIKit

class Circle: Shape {
    var radius: CGFloat
    var outline: Bool
    
    public required init(origin: CGPoint, color: UIColor, radius: CGFloat, outline: Bool){
        self.radius = radius
        self.outline = outline
        super.init(origin: origin, color: color)
    }
    
    public required init(origin: CGPoint, color: UIColor) {
        fatalError("init(origin:color:) has not been implemented")
    }
    
    override func draw() {	
        path.removeAllPoints()
        color.setFill()
        path.lineWidth = 5
        path.addArc(withCenter: origin, radius: radius, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        rotateHelper()
        if(!outline) {
            path.fill()
        }
        color.setStroke()
        path.stroke()
    }
    
    override func resize(by factor: CGFloat, currentWidth: CGFloat, currentHeight: CGFloat) {
        // resize the shape by a factor
        radius = currentWidth * factor
        draw()
    }

    func resize(by factor: CGFloat, currentRadius: CGFloat) {
        // resize the shape by a factor
        radius = currentRadius * factor
        draw()
    }

}
