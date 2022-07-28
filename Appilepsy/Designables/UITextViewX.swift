//
//  UITextViewX.swift
//  Nerd
//
//  Created by SachTech on 16/01/20.
//  Copyright © 2020 SachTech. All rights reserved.
//

import Foundation
//
//  DesignableUITextField.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/16/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

protocol UITextViewXDelegate {
    func onBackPressed(_ textField:UITextViewX)
}

@IBDesignable
class UITextViewX: UITextView {
    
    var xDelegate:UITextViewXDelegate?
 

  @objc func fix(textField: UITextField) {
  let t = textField.text
 // textField.text = String(t?.prefix(maxLength) ?? "")
  }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    private var _isRightViewVisible: Bool = true
    var isRightViewVisible: Bool {
        get {
            return _isRightViewVisible
        }
        set {
            _isRightViewVisible = newValue
            updateView()
        }
    }
    
    override func deleteBackward() {
        if text?.isEmpty ?? false{
            //resignFirstResponder()
            xDelegate?.onBackPressed(self)
        }
        else{
            super.deleteBackward()
        }
    }
    
    func updateView() {
       // setLeftImage()
       // setRightImage()
        
        // Placeholder text color
    }
    
    
    
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
}
