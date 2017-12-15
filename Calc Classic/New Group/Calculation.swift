//
//  Calculation.swift
//  Calc Classic
//
//  Created by Henry Tan on 13/12/17.
//  Copyright © 2017 Yarn Then. All rights reserved.
//

import Foundation

class Calculation {
    var sequence = [Arthmetic]()
    var sequencebackup = [Arthmetic]()
    var operatedby : Double?
    var operated : Double?
    var operation = "="
    var changeOfOperation = false
    var previousKey = keyPressed.Initial
    var displayInput: String = ""
    var display: String = ""
    var attrDisplay = [NSAttributedString(string: "")]
    let supporting = Supporting()
    init(_ hasParenthesis: Bool) {
        sequence.append(Arthmetic())
        if hasParenthesis{
            display = "("
            sequence[0].display = "("
        }
    }
    func operationPriority(_ Operation: String) -> Int{
        switch Operation{
        case "÷": return 2
        case "x": return 2
        case "+": return 1
        case "-": return 1
        default : return 0
        }
    }
    func calculated() -> Double?{
        attrDisplay.removeAll()
        if changeOfOperation {
            sequence = sequencebackup
            changeOfOperation = false
        }
        sequencebackup = sequence
        if sequence.count == 1 {
            /*
             MARK: Scenario 1a: Value (+-X÷)
             */
            if sequence[0].operated == nil{
                sequence[0].operated = operated
                sequence[0].operation = operation
                sequence[0].display =  sequence[0].display + displayInput + sequence[0].operation
                /*
                 MARK: Stripping additional parentheses. Eg ((Some equation)) is equal to (Some equation)
                 */
                if String(sequence[0].display.prefix(2)) == "((" && String(sequence[0].display.suffix(2)) == "))" {
                    sequence[0].display = String(String(sequence[0].display.dropFirst()).dropLast())
                }
                sequence[0].attrDisplay = supporting.createHighlighted(stringToConvert: sequence[0].display)
                display = sequence[0].display
                
                
            }else{
                sequence.append(Arthmetic())
                sequence[1].operated = operated
                sequence[1].operation = operation
                sequence[1].display =  sequence[1].display + displayInput + sequence[1].operation
                display = sequence[0].display + sequence[1].display
                /*
                 MARK: Scenario 2a: Value (+-) Value (x÷)
                 */
                if operationPriority(sequence[0].operation) < operationPriority(sequence[1].operation) {
                    sequence[0].attrDisplay = supporting.createNormal(stringToConvert: sequence[0].display)
                    sequence[1].attrDisplay = supporting.createHighlighted(stringToConvert: sequence[1].display)
                    /*
                     MARK: Scenario 2b: Value (+-) Value (+-) or Value (x÷) Value (x÷) or Value (x÷) Value (+-)
                     */
                }else{
                    sequence[0].operatedby = sequence[1].operated
                    sequence[0].operated = sequence[0].arthmetic()
                    sequence[0].operation = sequence[1].operation
                    sequence[0].display = sequence[0].display + sequence[1].display
                    sequence[0].attrDisplay = supporting.createHighlighted(stringToConvert: sequence[0].display)
                    sequence[0].operatedby = nil
                    sequence.removeLast()
                }
            }
        }else{
            sequence.append(Arthmetic())
            sequence[2].operated = operated
            sequence[2].operation = operation
            sequence[2].display =  displayInput + sequence[2].operation
            display = sequence[0].display + sequence[1].display + sequence[2].display
            /*
             MARK: Scenario 3a: Value (+-) Value (x÷) Value (x÷)
             */
            if operationPriority(sequence[1].operation) == operationPriority(sequence[2].operation) {
                sequence[1].operatedby = sequence[2].operated
                sequence[1].operated = sequence[1].arthmetic()
                sequence[1].operation = sequence[2].operation
                sequence[1].operatedby = nil
                sequence[1].display = sequence[1].display + sequence[2].display
                sequence[0].attrDisplay = supporting.createNormal(stringToConvert: sequence[0].display)
                sequence[1].attrDisplay = supporting.createHighlighted(stringToConvert: sequence[1].display)
                sequence.removeLast()
                /*
                 MARK: Scenario 3b: Value (+-) Value (x÷) Value (+-)
                 */
            }else {
                sequence[1].operatedby = sequence[2].operated
                sequence[0].operatedby = sequence[1].arthmetic()!
                sequence[0].operated = sequence[0].arthmetic()
                sequence[0].operation = sequence[2].operation
                sequence[0].display = sequence[0].display + sequence[1].display + sequence[2].display
                sequence[0].attrDisplay = supporting.createHighlighted(stringToConvert: sequence[0].display)
                sequence[0].operatedby = nil
                sequence.removeLast()
                sequence.removeLast()
            }
        }
        
        for sequencenumber in sequence {
            attrDisplay.append(sequencenumber.attrDisplay)
        }
        return sequence.last?.arthmetic()
    }
    
    
}
struct Arthmetic {
    var operatedby : Double?
    var operated : Double?
    var operation = "="
    var display: String = ""
    var attrDisplay = NSAttributedString(string: "")
    func arthmetic () -> Double? {
        if operatedby != nil {
            switch operation {
            case "÷":
                if operatedby != 0 { // to catch divide by 0 scenario
                    /*
                     //to prevent -0 scenario
                     */
                    if (operated! / operatedby!) == 0 {
                        return 0
                    }else{
                        return operated! / operatedby!
                    }
                }else{
                    return nil      //return nil if divide by 0
                }
            case "x":
                /*
                 //to prevent -0 scenario
                 */
                if (operated! * operatedby!) == 0 {
                    return 0
                }else{
                    return operated! * operatedby!
                }
            case "+":
                /*
                 //to prevent -0 scenario
                 */
                if (operated! + operatedby!) == 0 {
                    return 0
                }else{
                    return operated! + operatedby!
                }
            case "-":
                /*
                 //to prevent -0 scenario
                 */
                if (operated! - operatedby!) == 0 {
                    return 0
                }else{
                    return operated! - operatedby!
                }
            default : return operated!
            }
        }else {
            return operated!
        }
    }
}
