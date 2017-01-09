//
//  RoundedButton.swift
//  YesNo
//
//  Created by Jacopo Mangiavacchi on 12/21/16.
//  Copyright © 2016 Jacopo. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton
{
    @IBInspectable var rounded: Bool = false {
        willSet {
            if newValue {
                self.layer.cornerRadius = self.frame.size.height / 2
            }
            else{
                self.layer.cornerRadius = 0
            }
        }
    }
}

@IBDesignable class RoundedView: UIView
{
    @IBInspectable var rounded: Bool = false {
        willSet {
            if newValue {
                self.layer.cornerRadius = self.frame.size.height / 2
            }
            else{
                self.layer.cornerRadius = 0
            }
        }
    }
}
