//
//  ViewController.swift
//  BabyDraw
//
//  Created by Robert Perez on 2/23/17.
//  Copyright © 2017 Robert Perez. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var brushWidth: CGFloat = 100.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var clearCounter = 0
    var springSound: AVAudioPlayer!
    var sound: AVAudioPlayer!
    var settingsChecker = 0
    
    let screenSize: CGRect = UIScreen.main.bounds

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var fxSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settings button for sound FX
        registerSettingsBundle()
        updateDisplayFromDefaults()
        
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        //load sound effect, and prepare to play it on check so it doesnt lag on intial button press.
        let path = Bundle.main.path(forResource: "spring.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            springSound = sound
            sound?.prepareToPlay()
        } catch {
            // couldn't load file :(
        }
        
        reset.layer.cornerRadius = 4
        reset.layer.shadowOpacity = 1
        reset.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        reset.layer.shadowRadius = 0
        reset.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
        if screenWidth == Constants.iPhoneElseWidth{
           
           reset.titleLabel!.font =  UIFont(name: "Marker Comp", size: 30)
            
        }else if screenWidth == Constants.iPhone6Width{
           
            reset.titleLabel!.font =  UIFont(name: "Marker Comp", size: 40)
            
        }else if screenWidth >= Constants.iPhone6PlusWidth{
            
            reset.titleLabel!.font =  UIFont(name: "Marker Comp", size: 50)
            
        }else if screenWidth >= Constants.ipadWidth{
            
            reset.titleLabel!.font =  UIFont(name: "Marker Comp", size: 80)
        }

        
    }
    
    //settings bundle
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    //settings bundle
    func updateDisplayFromDefaults(){
        //Get the defaults
        let defaults = UserDefaults.standard
        
        //Set the controls to the default values.
        fxSwitch.isOn = defaults.bool(forKey: "soundFx")
        
        if !fxSwitch.isOn {
            settingsChecker = 1
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
        
        //clears screen after a number of points
        clearCounter += 1
        
        if clearCounter > 500 {
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
        
        if settingsChecker == 0 {
           sound.play()
        }
       
       imageView.image = nil
    }
    

}

