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
        
        self.layer.cornerRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 0
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        
    }

}
