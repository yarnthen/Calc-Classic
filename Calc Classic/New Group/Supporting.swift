//
//  Supporting.swift
//  Calc Classic
//
//  Created by Henry Tan on 13/12/17.
//  Copyright © 2017 Yarn Then. All rights reserved.
//

import Foundation
import UIKit

class Supporting {
    let font:UIFont? = UIFont(name: "Avenir-Book", size:40)
    let fontSub:UIFont? = UIFont(name: "Avenir-Book", size:20)
    let fontMain:UIFont? = UIFont(name: "Avenir-Book", size:18)
    let fontBold:UIFont? = UIFont(name: "Avenir-Book", size: 17)
    
    func convertToAttributeString(stringToConvert : String) -> NSMutableAttributedString {
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: stringToConvert, attributes: [NSAttributedStringKey.font:font!])
        attString.setAttributes([NSAttributedStringKey.font:fontSub!,NSAttributedStringKey.baselineOffset:-5], range: NSRange(location:1,length: stringToConvert.count - 1))
        return attString
    }
    
    func mergeToAttributeString(mainString: String, stringToConvert: String) ->NSMutableAttributedString {
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: mainString + stringToConvert, attributes: [NSAttributedStringKey.font:fontMain!])
        attString.setAttributes([NSAttributedStringKey.foregroundColor:UIColor.red ,NSAttributedStringKey.font:fontBold!], range: NSRange(location: mainString.count,length: stringToConvert.count))
        return attString
    }
    
    func mergeTwoAttributeString(stringToMerge: NSAttributedString, attributedStringToMerge: [NSAttributedString]) ->NSMutableAttributedString{
        let returnString = NSMutableAttributedString()
        returnString.append(stringToMerge)
        for attributedString in attributedStringToMerge {
            returnString.append(attributedString)
        }
        return returnString
    }
    
    func createHighlighted(stringToConvert: String) -> NSAttributedString {
        let attString = NSAttributedString(string: stringToConvert, attributes: [NSAttributedStringKey.foregroundColor:UIColor.red , NSAttributedStringKey.font:fontBold!])
        return attString
    }
    
    func createNormal(stringToConvert: String) -> NSAttributedString {
        let attString = NSAttributedString(string: stringToConvert, attributes: [NSAttributedStringKey.font:fontMain!])
        return attString
    }
    
    func numberFormat() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0  //set minimum number of decimal places to zero
        formatter.maximumFractionDigits = 10 //set maximum number of decimal places to ten
        formatter.minimumIntegerDigits = 1   //set minimum number of integer to one so that zero will show 0 instead of empty space
        return formatter
    }
    
    
}

