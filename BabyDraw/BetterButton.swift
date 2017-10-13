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
        self.layer.cornerRadius = 10
        
        
    }

}
