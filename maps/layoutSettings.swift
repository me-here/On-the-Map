//
//  layoutSettings.swift
//  maps
//
//  Created by Mihir Thanekar on 7/9/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
import UIKit

func setupTextField( _ textField: UITextField) {
    textField.borderStyle = .none   // Make the text field rectangular
    let bgColor = UIColor(red: 227/255, green: 203/255, blue: 194/255, alpha: 1.0)
    textField.backgroundColor = bgColor
    textField.returnKeyType = .done
}

func setupButton( _ button: UIButton, color: UIColor) {
    button.backgroundColor = color
    button.layer.cornerRadius = 0  // Un- round the button
}
