//
//  ViewController.swift
//  Calc Classic
//
//  Created by Henry Tan on 12/12/17.
//  Copyright © 2017 Yarn Then. All rights reserved.
//

import UIKit
import GoogleMobileAds
class ViewController: UIViewController, GADBannerViewDelegate  {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var operandButton: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var openParenthesis: UIButton!
    var arrayOfClasses = [Calculation]()
    var previousKey = keyPressed.Initial
    let supporting = Supporting()
    var toReset = false
    var operation = "="
    var equalSign = false
    var tempString = ""
    var tempAttrString = NSAttributedString(string: "")
    var displayValue: Double {
        get {
            let formatter = supporting.numberFormat()
            return formatter.number(from: resultLabel.text!)!.doubleValue
        }
        set {
            let formatter = supporting.numberFormat()
            resultLabel.text = formatter.string(from: NSNumber(value: newValue))
        }
    }
    var inputValue: Double {
        get {
            var tempValue = Double()
            let formatter = supporting.numberFormat()
            mainLabel.text = (mainLabel.text!.last == ".") ? String(mainLabel.text!.dropLast()) : mainLabel.text!
            tempValue = formatter.number(from: mainLabel.text!)!.doubleValue
            mainLabel.text = formatter.string(from: NSNumber(value: tempValue))
            return tempValue
        }
        set {
            let formatter = supporting.numberFormat()
            mainLabel.text = formatter.string(from: NSNumber(value: newValue))
        }
    }
    
    func resetEverything(){
        if equalSign {tempString = mainLabel.text!}
        if !equalSign {resultLabel.text = ""}
        if !equalSign {mainLabel.text = ""}
        smallLabel.text = ""
        operation = "="
        previousKey = equalSign ? .ValueLast  : .Initial
        openParenthesis.setAttributedTitle((NSMutableAttributedString(string: "(")), for: .normal)
        arrayOfClasses.removeAll()
        arrayOfClasses.append(Calculation(false))
        removeFocus()
        equalSign = false
        toReset = false
    }
    
    func removeFocus() {
        for button in operandButton{
            button.backgroundColor = UIColor(displayP3Red: 0.601635, green: 0.722486, blue: 0.933891, alpha: 1)
        }
    }
    
    func consolidatedOperation() -> String?{
        var displayText = String()
        if arrayOfClasses.count > 1 {
            for count in 0...arrayOfClasses.count-2{
                displayText += arrayOfClasses[count].display
            }
        }
        return displayText
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        arrayOfClasses.append(Calculation(false))
        bannerView.isHidden = true
        bannerView.delegate = self
        bannerView.adUnitID = ""
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clearPressed(_ sender: UIButton) {
        if sender.currentTitle == "CE"{
            mainLabel.text = ""
            previousKey = .ResetCurrent
            sender.setTitle("C", for: .normal)
        }else{
            equalSign = false
            resetEverything()
        }
    }
    @IBAction func invertPressed(_ sender: UIButton) {
        if previousKey == .Value {
            if inputValue != 0 {
                inputValue.negate()
            }
        }
    }
    @IBAction func digitPressed(_ sender: UIButton) {
        if toReset {
            resetEverything()
        }
        /*
         //  MARK: Rule - Cannot use digit if it is preceded by last digit/decimal(ValueLast)
         */
        if previousKey != .ValueLast {
            let digit = sender.currentTitle!
            
            /* MARK: Scenario Digit 1a: Not 1st digit */
            /* MARK: Ouput    Digit 1a: mainLabel.text = mainLabel.text + Digit */
            /* MARK: Scenario Digit 1b: 1st digit */
            /* MARK: Output   Digit 1b: mainLabel.text = Digit */
            
            mainLabel.text = ((previousKey == .Value || previousKey != .ResetCurrent) && mainLabel.text != "0") ? mainLabel.text! + digit : digit
            previousKey = .Value
            clearButton.setTitle("CE", for: .normal)
            removeFocus()
        }
    }
    @IBAction func decimalPressed(_ sender: UIButton) {
        if toReset {
            resetEverything()
        }
        /*
         //  MARK: Rule - Cannot use decimal if it is preceded by last digit/decimal(ValueLast) or if there is already a decimal
         */
        if (previousKey != .ValueLast && !(mainLabel.text!.contains("."))){
            /*
             // MARK: Scenario Decimal 1a: Not 1st digit
             // MARK: Output   Decimal 1a: mainLabel.text = mainLabel.text + Decimal
             // MARK: Scenario Decimal 1b: 1st digit
             // MARK: Ouput    Decimal 1b: mainLabel.text = 0.
             */
            mainLabel.text = (previousKey == .Value && previousKey != .ResetCurrent) ? mainLabel.text! + "." : "0."
            previousKey = .Value
            clearButton.setTitle("CE", for: .normal)
            removeFocus()
            
        }
    }
    @IBAction func operationPressed(_ sender: UIButton) {
        let displayText = consolidatedOperation() ?? ""
        if toReset {
            resetEverything()
        }
        /*
         // MARK: Rule - Cannot use equal if there are open bracket
         // MARK: Rule - Cannot use other operation if this is initial or previousKey is Open
         */
        if ((sender.currentTitle == "=" && arrayOfClasses.count == 1) || (sender.currentTitle != "=")) && (previousKey != .Initial && previousKey != .Open && previousKey != .ResetCurrent) {
            if let currentClass = arrayOfClasses.last {
                /*
                 // MARK: Scenario Operation 1a - Value to be operated is inputted
                 // MARK: Output   Operation 1a - Set Operated to inputValue
                 // MARK: Scenario Operation 1b - Value to be operated is derived (from a parenthesis)
                 // MARK: Output   Operation 1b - Set Operated to displayValue
                 */
                if previousKey != .Operation {
                    currentClass.operated = (previousKey == .Value) ? inputValue : displayValue
                    currentClass.displayInput = (previousKey == .Value) ? ((inputValue < 0 ) ? "(" + mainLabel.text! + ")" : mainLabel.text!) : tempString
                    /*
                     // MARK: Scenario Operation 1c - Change of Operation, no calculation
                     // MARK: Output   Operation 1c - Set flag of changeOfOperation in the class to True
                     */
                }else{
                    currentClass.changeOfOperation = true
                }
                currentClass.operation = sender.currentTitle!
                toReset = (sender.currentTitle == "=")
                equalSign = (sender.currentTitle == "=")
                removeFocus()
                sender.backgroundColor = UIColor.cyan
                mainLabel.text = ""
                if let calculatedValue = currentClass.calculated() {
                    displayValue = calculatedValue
                    if (sender.currentTitle == "=") {inputValue = calculatedValue}
                }else{
                    mainLabel.text = "Divide by Zero"
                    toReset = true
                }
                
                smallLabel.attributedText = supporting.mergeTwoAttributeString(stringToMerge: supporting.createNormal(stringToConvert: displayText), attributedStringToMerge: currentClass.attrDisplay)
            }
            clearButton.setTitle("C", for: .normal)
            if mainLabel.text != "Divide by Zero"{
                previousKey = .Operation
            }
        }
    }
    @IBAction func openParenthesisPressed(_ sender: UIButton) {
        let smallLabelText = smallLabel.text ?? ""
        if toReset {
            resetEverything()
        }
        /*
         //  MARK: Rule - Cannot use Open if it is preceded by Value or ValueLast(Close)
         */
        if !(previousKey == .Value || previousKey == .ValueLast){
            mainLabel.text = ""
            arrayOfClasses.append(Calculation(true))
            smallLabel.text = smallLabelText + "("
            previousKey = .Open
            let attString = supporting.convertToAttributeString(stringToConvert: "(\(arrayOfClasses.count - 1)")
            openParenthesis.setAttributedTitle(attString, for: .normal)
            clearButton.setTitle("C", for: .normal)
            removeFocus()
        }
    }
    @IBAction func closeParenthesisPressed(_ sender: UIButton) {
        let displayText = consolidatedOperation() ?? ""
        if toReset {
            resetEverything()
        }
        /*
         /*  MARK: Rule - Cannot use close if it is preceded by operation or initial or open and if there is no open */
         */
        if arrayOfClasses.count > 1 && !(previousKey == .Open || previousKey == .Operation || previousKey == .Initial || previousKey == .ResetCurrent){
            
            if let currentClass = arrayOfClasses.last {
                currentClass.operated = previousKey == .Value ? inputValue : displayValue
                currentClass.displayInput = (previousKey == .Value) ? ((inputValue < 0 ) ? "(" + mainLabel.text! + ")" : mainLabel.text!) : tempString
                currentClass.operation = ")"
                if let calculatedValue = currentClass.calculated() {
                    displayValue = calculatedValue
                    tempString = currentClass.display
                    smallLabel.attributedText = supporting.mergeTwoAttributeString(stringToMerge: supporting.createNormal(stringToConvert: displayText), attributedStringToMerge: currentClass.attrDisplay)
                }else{
                    mainLabel.text = "Divide by Zero"
                    toReset = true
                }
            }
            if mainLabel.text != "Divide by Zero" {
                arrayOfClasses.removeLast()
                
                if let previousClass = arrayOfClasses.last{
                    /*
                     // MARK: Post Preparation Result   Close 2 - previousClass.display += display
                     */
                    previousClass.displayInput = tempString
                    
                    
                    /*
                     // MARK: Post Action Close - clear mainLabel.text
                     */
                    mainLabel.text = ""
                    /*
                     // MARK: Post Action Close - set previousKey to ValueLast
                     */
                    clearButton.setTitle("C", for: .normal)
                    previousKey = .ValueLast
                    if arrayOfClasses.count == 1 {
                        openParenthesis.setAttributedTitle((NSMutableAttributedString(string: "(")), for: .normal)
                    }else{
                        let attString = supporting.convertToAttributeString(stringToConvert: "(\(arrayOfClasses.count - 1)")
                        openParenthesis.setAttributedTitle(attString, for: .normal)
                    }
                }
            }
            
        }
    }
    
}

