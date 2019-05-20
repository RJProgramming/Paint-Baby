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

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

class ViewController: UIViewController {
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var brushWidth: CGFloat = 20.0
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
    @IBOutlet weak var sa1: UIButton!
    @IBOutlet weak var sa2: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var saveLabel2: UILabel!
    @IBOutlet weak var saveLabel3: UILabel!
    @IBOutlet weak var clearButton: BetterButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settings button for sound FX
        registerSettingsBundle()
        updateDisplayFromDefaults()
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : -4.0,
            ] as [NSAttributedString.Key : Any]
        
        saveLabel3.attributedText = NSAttributedString(string: "To save your drawing", attributes: strokeTextAttributes as [String : Any])
        saveLabel.attributedText = NSAttributedString(string: "tap both save buttons", attributes: strokeTextAttributes as [String : Any])
        saveLabel2.attributedText = NSAttributedString(string: "at the same time", attributes: strokeTextAttributes as [String : Any])
        
        //prevents app from stopping backgorund audio
        let audioSession = AVAudioSession.sharedInstance()
        
        
        try!audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSession.CategoryOptions.mixWithOthers) //Causes audio from other sessions to be ducked (reduced in volume) while audio from this session plays
        
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
        
   
        
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        imageView.layer.shadowRadius = 0
        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
 
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification,object: nil)
        
    }
    
    @objc func defaultsChanged(){
        updateDisplayFromDefaults()
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
        
        if fxSwitch.isOn {
            settingsChecker = 0
        }else{
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
        
        saveLabel.isHidden = true
        saveLabel2.isHidden = true
        saveLabel3.isHidden = true
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
        
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Please allow Paint Baby access to camera roll in settings to save images.", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Saved to camera roll!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        
        if settingsChecker == 0 {
           sound.play()
           sound.volume = 0.4
        }
      
        clearButton.transform = CGAffineTransform(translationX: 15, y: 0)
        //clearButton.transform = CGAffineTransform(translationX: -15, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.clearButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
       imageView.image = nil
    }
    
    @IBAction func vE(_ sender: Any) {
        
        saveLabel.isHidden = true
        saveLabel2.isHidden = true
        saveLabel3.isHidden = true
        
        if imageView.image != nil{
            if sa1.isHighlighted && sa2.isHighlighted {
                UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                saveLabel.isHidden = true
                saveLabel2.isHidden = true
                saveLabel3.isHidden = true
            }
        }
        animateSaveButtons(sender: sa2)
    }
    
    @IBAction func vELetGo(_ sender: Any) {
        
        if sa1.isHighlighted && sa2.isHighlighted {
            saveLabel.isHidden = true
            saveLabel2.isHidden = true
            saveLabel3.isHidden = true
        }else{
            saveLabel.isHidden = false
            saveLabel2.isHidden = false
            saveLabel3.isHidden = false
        }
         animateSaveButtons(sender: sa2)
    }
    
    
    @IBAction func sA(_ sender: Any) {
        
        saveLabel.isHidden = true
        saveLabel2.isHidden = true
        saveLabel3.isHidden = true
        
        if imageView.image != nil{
            if sa1.isHighlighted && sa2.isHighlighted {
                UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                saveLabel.isHidden = true
                saveLabel2.isHidden = true
                saveLabel3.isHidden = true
                
            }
        }
        animateSaveButtons(sender: sa1)
    }
    
    @IBAction func sALetGo(_ sender: Any) {
        
        if sa1.isHighlighted && sa2.isHighlighted {
            saveLabel.isHidden = true
            saveLabel2.isHidden = true
            saveLabel3.isHidden = true
        }else{
            saveLabel.isHidden = false
            saveLabel2.isHidden = false
            saveLabel3.isHidden = false
        }
        animateSaveButtons(sender: sa1)
    }
    
    func animateSaveButtons(sender: UIButton){
    
    sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
    sender.transform = CGAffineTransform.identity
    }, completion: nil)
    
    }

}

