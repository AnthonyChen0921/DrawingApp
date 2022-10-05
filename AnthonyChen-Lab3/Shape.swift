//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    var origin: CGPoint
    var color: UIColor
    var angle: CGFloat
    var path: UIBezierPath

    public required init(origin: CGPoint, color: UIColor){
        self.origin = CGPoint(x: origin.x, y: origin.y)
        self.color = color
        self.angle = 0
        self.path = UIBezierPath()
    }
    
    func draw() {
        self.draw()
    }
    
    func contains(point: CGPoint) -> Bool {
        return path.contains(point)
    }

    func move(to point: CGPoint) {
        // update origin and update the path
        origin = point
        self.draw()
    }

    func resize(by factor: CGFloat, currentWidth: CGFloat, currentHeight: CGFloat) {
        self.resize(by: factor, currentWidth: currentWidth, currentHeight: currentHeight)
    }

    func rotate(by angle: CGFloat) {
        self.angle = angle
        self.draw()
    }

    func rotateHelper() {
        // rotate the shape by an angle
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: origin.x, y: origin.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -origin.x, y: -origin.y)
        self.path.apply(transform)
    }
}


