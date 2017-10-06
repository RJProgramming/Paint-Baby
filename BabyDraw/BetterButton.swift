//
//  BetterButton.swift
//  BabyDraw
//
//  Created by Robert Perez on 3/1/17.
//  Copyright © 2017 Robert Perez. All rights reserved.
//

import UIKit

class BetterButton: UIButton {

    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.titleLabel!.font = UIFont(name: "Marker Comp", size: 28)
        self.titleLabel?.minimumScaleFactor = 0.4
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        //self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        self.layer.cornerRadius = 10
        //self.layer.shadowOpacity = 0.5
       // self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
       //self.layer.shadowRadius = 30
       //self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
    }

}
