//
//  ViewController.swift
//  AnthonyChen-Lab3
//
//  Created by Anthony C on 9/21/22.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // timer
    var timer = Timer()
    // auto pilot
    var autoPilot: Bool = false

    // store current shape
    var currentShape: Shape?
    // store current Shape selected by button group
    var currentShapeSelected: String?
    // default color set to red
    var currentColor: UIColor = UIColor.red
    // color string
    var currentButtonColor: String = "red"
    // current selected moving shape
    var moveShapeCurrent: Shape?
    // current selected resizing shape
    var resizeShapeCurrent: Shape?
    // current selected rotating shape
    var rotateShapeCurrent: Shape?

    var currentWidth: CGFloat = 30.0
    var currentHeight: CGFloat = 30.0
    var currentRadius: CGFloat = 30.0
    
    // mode arr
    var modeArr: [String] = ["draw", "move", "erase"]
    var currentMode: String = "draw"

    // color button
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!

    @IBOutlet weak var pageControl: UIPageControl!
    // drawing canvas
    @IBOutlet weak var shapeCanvas: DrawingView!
    
    // map string to button
    var buttonMap: [String: UIButton] = [:]
    // array of all buttons color
    var buttonColors: [String] = ["red", "orange", "purple", "blue", "green", "yellow"]
    // array of all shape
    var shapeArr: [String] = ["OutlineRectangle", "SolidRectangle", "OutlineCircle", "SolidCircle", "OutlineTriangle", "SolidTriangle"]
    
    // declare pinch gesture
   // @objc var pinchGesture: UIPinchGestureRecognizer!
    
    //@IBOutlet weak var canvas: DrawingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(shapeCanvas)
        // add background color to shapeCanvas
        shapeCanvas.backgroundColor = UIColor.white

        // run timer
        runTimer()

        currentShapeSelected = "OutlineRectangle"
        
        // map the string to actual button
        buttonMap["red"] = redButton
        buttonMap["orange"] = orangeButton
        buttonMap["purple"] = purpleButton
        buttonMap["blue"] = blueButton
        buttonMap["green"] = greenButton
        buttonMap["yellow"] = yellowButton


        // add gesture recognizer
        addGesture()
    }
    @IBAction func autoPliotEngaged(_ sender: Any) {
        autoPilot = !autoPilot
    }
    @objc func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        if(autoPilot && shapeCanvas.items.count <= 100){
            // create random point
            let randomX = CGFloat.random(in: 0...shapeCanvas.frame.width)
            let randomY = CGFloat.random(in: 0...shapeCanvas.frame.height)
            let randomPoint = CGPoint(x: randomX, y: randomY)
            // create random color
            let randomColor = buttonColors.randomElement()
            // change current color to random color
            currentColor = randomColor!.toUIColor()
            // create random shape
            let randomShape = shapeArr.randomElement()
            // change current shape to random shape
            currentShapeSelected = randomShape
            // init shape
            shapeSelectorImplementor(shape: currentShapeSelected!, point: randomPoint)
            shapeCanvas.items.append(currentShape!)
            
            // update timer
            // print(randomPoint)
            // draw random shape
        }
  
    }
    @IBAction func pageChanged(_ sender: Any) {
        // change shapeCanvas background color when page changed
        // call pageChangeImplementor
        pageChangeImplementor(num: pageControl.currentPage)
    }
    func pageChangeImplementor(num: Int) {
        switch num {
        case 0:
            shapeCanvas.backgroundColor = UIColor.white
        case 1:
            shapeCanvas.backgroundColor = UIColor.systemGray4
        case 2:
            shapeCanvas.backgroundColor = UIColor.lightGray
        case 3:
            shapeCanvas.backgroundColor = UIColor.gray
        case 4:
            shapeCanvas.backgroundColor = UIColor.systemOrange
        case 5:
            shapeCanvas.backgroundColor = UIColor.systemRed
        case 6:
            shapeCanvas.backgroundColor = UIColor.systemPink
        case 7:
            shapeCanvas.backgroundColor = UIColor.systemMint
        case 8:
            shapeCanvas.backgroundColor = UIColor.systemCyan
        default:
            shapeCanvas.backgroundColor = UIColor.white
        }
    }
    
    // tutorial from https://www.youtube.com/watch?v=v6XQlgqCw18
    // only reference how to get a scale from gesture recoginzer
    // other logic such as how to check item selected,
    // how to store width height before resize,
    // and call resize function of the shape class
    // are all came up with myself
    func addGesture() {
        // add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        shapeCanvas.addGestureRecognizer(pinchGesture)
        // add rotation gesture
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        shapeCanvas.addGestureRecognizer(rotationGesture)
        // add swipe gesture
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureLeft.direction = .left
        shapeCanvas.addGestureRecognizer(swipeGestureLeft)
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRight.direction = .right
        shapeCanvas.addGestureRecognizer(swipeGestureRight)
    }
    @objc func didSwipe(_ gesture: UISwipeGestureRecognizer){
        if gesture.state == .ended{
            // if right swipe, minus 1 to pageControl
            if gesture.direction == .right{
                // loop back to last page
                if pageControl.currentPage == 0{ pageControl.currentPage = pageControl.numberOfPages - 1}
                else{pageControl.currentPage -= 1}
                pageChangeImplementor(num: pageControl.currentPage)
            }
            // if left swipe, plus 1 to pageControl
            else if gesture.direction == .left{
                // loop back to first page
                if pageControl.currentPage == pageControl.numberOfPages - 1{ pageControl.currentPage = 0}
                else{pageControl.currentPage += 1}
                pageChangeImplementor(num: pageControl.currentPage)
            }
            
        }
    }

    func updateResizeShape(touchPoint: CGPoint) {
        // check all canvas items if they contain the pinch point
        for shape in shapeCanvas.items {
            // downcast to shape
            if let shape = shape as? Shape {
                 // check if the shape contains the pinch point
                 if shape.contains(point: touchPoint) {
                     resizeShapeCurrent = shape
                     break
                 }
            }
        }
    }
    func storeWidthHeight() {
        //store resizeShapeCurrent width and height
        if let resizeShape = resizeShapeCurrent {
            if let rect = resizeShape as? Rectangle {
                currentWidth = Double(rect.width)
                currentHeight = Double(rect.height)
            }
            if let circle = resizeShape as? Circle {
                currentRadius = Double(circle.radius)
            }
            if let triangle = resizeShape as? Triangle {
                currentWidth = Double(triangle.width)
                currentHeight = Double(triangle.height)
            }
        }
    }
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        // get the pinch point and check if it is in any shape
        updateResizeShape(touchPoint: gesture.location(in: shapeCanvas))
        
        // store the current shape width and height before resizing
        if gesture.state == .began{
            storeWidthHeight()
        }
         
        // update the scale of the shape
        if gesture.state == .changed {
            let scale = gesture.scale
            // call resize on resizeShapeCurrent
            if let resizeShape = resizeShapeCurrent {
                if let rect = resizeShape as? Rectangle {
                    rect.resize(by: scale, currentWidth: currentWidth, currentHeight: currentHeight)
                }
                if let circle = resizeShape as? Circle {
                    circle.resize(by: scale, currentRadius: currentRadius)
                }
                if let triangle = resizeShape as? Triangle {
                    triangle.resize(by: scale, currentWidth: currentWidth, currentHeight: currentHeight)
                }
            }
            shapeCanvas.setNeedsDisplay()
        }
    }
    func updateRotateShapeCurrent(touchPoint: CGPoint) {
        // check all canvas items if they contain the pinch point
        for shape in shapeCanvas.items {
            // downcast to shape
            if let shape = shape as? Shape {
                 // check if the shape contains the pinch point
                 if shape.contains(point: touchPoint) {
                     rotateShapeCurrent = shape
                     break
                 }
            }
        }
    }
    @objc func didRotate(_ gesture: UIRotationGestureRecognizer){
        // get the pinch point and check if it is in any shape
        updateRotateShapeCurrent(touchPoint: gesture.location(in: shapeCanvas))
        
        // update the scale of the shape
        if gesture.state == .changed {
            let angle = gesture.rotation
            // call rotate on rotateShapeCurrent
            if let rotateShape = rotateShapeCurrent {
                rotateShape.rotate(by: angle)
            }
            shapeCanvas.setNeedsDisplay()
        }   
        if gesture.state == .ended {
            rotateShapeCurrent = nil
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the touch
        let touchPoint = getTouchPoint(touches)
        // if mode is draw
        if currentMode == "draw"{
            shapeSelectorImplementor(shape: currentShapeSelected!, point: touchPoint)
            shapeCanvas.items.append(currentShape!)
        }
        // if mode is erase, check if touch point is in shape
        else if currentMode == "erase"{
            deleteShapeOnClickImplementor(_touchPoint: touchPoint)
        }
        // if mode is move
        else if currentMode == "move"{
            moveShapeOnClickImplementor(_touchPoint: touchPoint)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentMode == "move"{
            // move shape to new point by calling move function
            let touchPoint = getTouchPoint(touches)
            moveShapeCurrent?.move(to: touchPoint)
            shapeCanvas.setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if mode is move, set moveShapeCurrent to nil
        if currentMode == "move"{
            moveShapeCurrent = nil
        }
        resizeShapeCurrent = nil
        rotateShapeCurrent = nil
    }

    private func gestureRecognizer(_ gestureRecognizer: UIRotationGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIPinchGestureRecognizer) -> Bool {
        true 
    }
    
    

    // Implementor
    // shapeSelectorIMplementor update the current shape selected according to the selected segment
    func shapeSelectorImplementor (shape: String, point: CGPoint) {
        switch shape {
        case "OutlineRectangle":
            currentShape = Rectangle(origin: point, color: currentColor, width: 80, height: 80, outline: true)
        case "OutlineCircle":
            currentShape = Circle(origin: point, color: currentColor, radius: 40, outline: true)
        case "OutlineTriangle":
            currentShape = Triangle(origin: point, color: currentColor, width: 100, height:100, outline: true)
        case "SolidRectangle":
            currentShape = Rectangle(origin: point, color: currentColor, width: 80, height: 80, outline: false)
        case "SolidCircle":
            currentShape = Circle(origin: point, color: currentColor, radius: 40, outline: false)
        case "SolidTriangle":
            currentShape = Triangle(origin: point, color: currentColor, width: 100, height:100, outline: false)
        default:
            currentShape = Rectangle(origin: point, color: currentColor, width: 80, height: 80, outline: true)
        }
    }

    // Implementor
    // delete shape on click
    func deleteShapeOnClickImplementor(_touchPoint: CGPoint) {
        // loop through the array of shapes
        // if the touch point is in the shape, remove the shape from the array
        for shape in shapeCanvas.items{
            if shape.contains(point: _touchPoint){
                shapeCanvas.items.remove(at: shapeCanvas.items.firstIndex(where: {$0 === shape})!)
                break
            }
        }
    }

    // Implementor
    // move shape on drag
    func moveShapeOnClickImplementor(_touchPoint: CGPoint){
        // check if touch point is in shape
        for shape in shapeCanvas.items{
            if shape.contains(point: _touchPoint){
                if let shape = shape as? Shape{
                        moveShapeCurrent = shape
                        break
                    }
            }
        }
    }

    // change current shape selected
    @IBAction func shapeSelector(_ sender: Any) {
        // get the selected segment by index
        let selectedSegment = (sender as! UISegmentedControl).selectedSegmentIndex
        // set the current shape selected
        switch selectedSegment {
        case 0:
            currentShapeSelected = "OutlineRectangle"
        case 1:
            currentShapeSelected = "OutlineCircle"
        case 2:
            currentShapeSelected = "OutlineTriangle"
        case 3:
            currentShapeSelected = "SolidRectangle"
        case 4:
            currentShapeSelected = "SolidCircle"
        case 5:
            currentShapeSelected = "SolidTriangle"
        default:
            currentShapeSelected = "OutlineRectangle"
        }
    }
    
    // change the mode of the app
    @IBAction func modeSelector(_ sender: Any) {
        // update the current mode
        let selectedSegment = (sender as! UISegmentedControl).selectedSegmentIndex
        currentMode = modeArr[selectedSegment]
        //print("current mode is \(currentMode)")
    }
    
    // switch display when color button is clicked
    @IBAction func redColorClicked(_ sender: Any) {
        currentColor = UIColor.systemRed
        // change the opacity of the button
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "red")
    }
    @IBAction func orangleColorClicked(_ sender: Any) {
        currentColor = UIColor.systemOrange
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "orange")
    }
    @IBAction func yellowColorClicked(_ sender: Any) {
        currentColor = UIColor.systemYellow
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "yellow")
    }
    @IBAction func greenColorClicked(_ sender: Any) {
        currentColor = UIColor.systemGreen
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "green")
    }
    @IBAction func blueColorClicked(_ sender: Any) {
        currentColor = UIColor.systemCyan
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "blue")
    }
    @IBAction func purpleColorClicked(_ sender: Any) {
        currentColor = UIColor.systemPurple
        (sender as! UIButton).alpha = 1
        clearOtherButtonOpacity(currentButtonColor: "purple")
    }

    // clear the canvas
    @IBAction func clearAllShape(_ sender: Any) {
        shapeCanvas.items = []
        shapeCanvas.setNeedsDisplay()
    }

    // shortcut func clear
    func clearCanvas(){
        shapeCanvas.items = []
        shapeCanvas.setNeedsDisplay()
    }

    // Helper
    // clear the opacity of other buttons
    func clearOtherButtonOpacity(currentButtonColor: String) {
        // loop through the array of buttonColors
        // if the button color is not the current button color, set the opacity to 0.5 using the buttonMap to get the button
        for color in buttonColors {
            if color != currentButtonColor {
                buttonMap[color]?.alpha = 0.5
            }
        }
    }

    // Helper
    // function to offset the touch point to the center of the shape
    // take in CGPoint
    func touchPointDeviationOffset(point: CGPoint) -> CGPoint {
        let x = point.x
        let y = point.y - 92
        return CGPoint(x: x, y: y)
    }

    // Helper
    // get the touch point
    func getTouchPoint(_ touches: Set<UITouch>) -> CGPoint{
        guard touches.count == 1,
                  var touchPoint = touches.first?.location(in: view)
            else { return CGPoint(x: 0, y: 0) }
        touchPoint = touchPointDeviationOffset(point: touchPoint as CGPoint)
        return touchPoint
    }

}


extension String {
    func toUIColor() -> UIColor {
        switch self {
        case "red":
            return UIColor.systemRed
        case "orange":
            return UIColor.systemOrange
        case "yellow":
            return UIColor.systemYellow
        case "green":
            return UIColor.systemGreen
        case "blue":
            return UIColor.systemCyan
        case "purple":
            return UIColor.systemPurple
        default:
            return UIColor.systemRed
        }
    }
}
