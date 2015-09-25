//
//  globalFuncs.swift
//  Pivit
//
//  Created by Jared on 9/14/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import Foundation

func PivitColor() -> UIColor {
    return UIColor(red: 23.0 / 255.0, green: 243.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
}

func darkGreenColor() -> UIColor {
    return UIColor(red: 51.0 / 255.0, green: 204.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
}

func sanitizeMoney(string string: String) -> Double? {
    let stringWithoutDollarSignandCommas = string.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
    if let money = Double(stringWithoutDollarSignandCommas) {
        return money
    } else {
        return nil
    }
}