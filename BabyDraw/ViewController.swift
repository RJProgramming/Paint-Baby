//
//  ViewController.swift
//  BabyDraw
//
//  Created by Robert Perez on 2/23/17.
//  Copyright © 2017 Robert Perez. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var brushWidth: CGFloat = 100.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var clearCounter = 0
    
    let screenSize: CGRect = UIScreen.main.bounds

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reset: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        
        if screenWidth == Constants.iPhoneElseWidth{
           
           reset.titleLabel!.font =  UIFont(name: "Upheaval TT (brk)", size: 60)
            
        }else if screenWidth == Constants.iPhone6Width{
           
            reset.titleLabel!.font =  UIFont(name: "Upheaval TT (brk)", size: 75)
            
        }else if screenWidth >= Constants.iPhone6PlusWidth{
            
            reset.titleLabel!.font =  UIFont(name: "Upheaval TT (brk)", size: 80)
            
        }else if screenWidth >= Constants.ipadWidth{
            
            reset.titleLabel!.font =  UIFont(name: "Upheaval TT (brk)", size: 150)
        }

        
    }
    
    struct Constants {
        
        static let iPhone6Width = CGFloat(375)
        static let iPhone6PlusWidth = CGFloat(414)
        static let iPhoneElseWidth = CGFloat(320)
        static let iPhone4Height = CGFloat(480)
        static let ipadWidth = CGFloat(1024)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        red = randomCGFloat(min: 0, max: 1)
        green = randomCGFloat(min: 0, max: 1)
        blue = randomCGFloat(min: 0, max: 1)
        
        print("red: \(red)")
        print("green: \(green)")
        print("blue: \(blue)")
        
        
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            
        }
    }
    
    func drawLineFrom(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        imageView.image?.draw(in: view.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
        
        clearCounter += 1
        
        if clearCounter > 20 {
            imageView.image = nil
            clearCounter = 0
        }
        
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(from: lastPoint, to: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            self.drawLineFrom(from: lastPoint, to: lastPoint)
        }
    }
    
    func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
    }
    

}

