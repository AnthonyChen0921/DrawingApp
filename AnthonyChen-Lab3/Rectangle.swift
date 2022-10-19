//
//  Rectangle.swift
//  AnthonyChen-Lab3
//
//  Created by Anthony C on 10/1/22.
//
import UIKit

class Rectangle: Shape {
    var width: CGFloat
    var height: CGFloat
    var outline: Bool
    
    public required init(origin: CGPoint, color: UIColor, width: CGFloat, height: CGFloat, outline: Bool){
        self.width = width
        self.height = height
        self.outline = outline
        super.init(origin: origin, color: color)
    }
    
    public required init(origin: CGPoint, color: UIColor) {
        fatalError("init(origin:color:) has not been implemented")
    }
    
    override func draw() {
        // add rectangle by center origin
        path.removeAllPoints()
        color.setFill()
        path.lineWidth = 5
        path.move(to: CGPoint(x: origin.x - width/2, y: origin.y - height/2))
        path.addLine(to: CGPoint(x: origin.x + width/2, y: origin.y - height/2))
        path.addLine(to: CGPoint(x: origin.x + width/2, y: origin.y + height/2))
        path.addLine(to: CGPoint(x: origin.x - width/2, y: origin.y + height/2))
        path.close()
        rotateHelper()
        if(!outline) {
            path.fill()
        }
        color.setStroke()
        path.stroke()
    }

    
     override func resize(by factor: CGFloat, currentWidth: CGFloat, currentHeight: CGFloat) {
         // resize the shape by a factor
         width = currentWidth * factor
         height = currentHeight * factor
         draw()
     }

}
