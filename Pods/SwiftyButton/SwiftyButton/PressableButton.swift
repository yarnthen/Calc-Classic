//
//  PressableButton.swift
//  SwiftyButton
//
//  Created by Lois Di Qual on 10/23/16.
//  Copyright © 2016 TakeScoop. All rights reserved.
//

import UIKit

@IBDesignable
open class PressableButton: UIButton {
    
    public enum Defaults {
        public static var colors = ColorSet(
            button: UIColor.white,
            shadow: UIColor.lightGray
        )
        public static var disabledColors = ColorSet(
            button: UIColor.lightGray ,
            shadow: UIColor.gray
        )
        public static var shadowHeight: CGFloat = 3
        public static var depth: Double = 0.7
        public static var cornerRadius: CGFloat = 3
    }
    
    public struct ColorSet {
        let button: UIColor
        let shadow: UIColor
        
        public init(button: UIColor, shadow: UIColor) {
            self.button = button
            self.shadow = shadow
        }
    }
    
    public var colors: ColorSet = Defaults.colors {
        didSet {
            updateBackgroundImages()
        }
    }
    
    public var disabledColors: ColorSet = Defaults.disabledColors {
        didSet {
            updateBackgroundImages()
        }
    }
    
    @IBInspectable
    public var shadowHeight: CGFloat = Defaults.shadowHeight {
        didSet {
            updateBackgroundImages()
            updateTitleInsets()
        }
    }
    
    @IBInspectable
    public var depth: Double = Defaults.depth {
        didSet {
            updateBackgroundImages()
            updateTitleInsets()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = Defaults.cornerRadius {
        didSet {
            updateBackgroundImages()
        }
    }
    @IBInspectable
    public var buttonColor: UIColor = Defaults.colors.button {
        didSet {
            updateBackgroundImages()
        }
    }
    @IBInspectable
    public var disabledShadowColor: UIColor = Defaults.colors.button {
        didSet {
            updateBackgroundImages()
        }
    }
    
    @IBInspectable
    public var disabledButtonColor: UIColor = Defaults.colors.button {
        didSet {
            updateBackgroundImages()
        }
    }
    @IBInspectable
    public var shadowColor: UIColor = Defaults.colors.button {
        didSet {
            updateBackgroundImages()
        }
    }
    
    // MARK: - UIButton
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        updateBackgroundImages()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        updateBackgroundImages()
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateTitleInsets()
        }
    }
    
    // MARK: - Internal methods
    
    func configure() {
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
    
    func updateTitleInsets() {
        let topPadding = isHighlighted ? shadowHeight * CGFloat(depth) : 0
        let bottomPadding = isHighlighted ? shadowHeight * (1 - CGFloat(depth)) : shadowHeight
        titleEdgeInsets = UIEdgeInsets(top: topPadding, left: 0, bottom: bottomPadding, right: 0)
    }
    
    fileprivate func updateBackgroundImages() {
        
        let normalImage = Utils.buttonImage(color: buttonColor, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius)
        let highlightedImage = Utils.highlightedButtonImage(color: buttonColor, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius, buttonPressDepth: depth)
        let disabledImage = Utils.buttonImage(color: disabledButtonColor, shadowHeight: shadowHeight, shadowColor: disabledShadowColor, cornerRadius: cornerRadius)
        
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
        //setBackgroundImage(disabledImage, for: .disabled)
        setBackgroundImage(disabledImage, for: .selected)
    }
}
