//
//  SignupViewController.swift
//  FadeExample
//
//  Created by Ryan Fitzgerald on 9/19/14.
//  Copyright (c) 2014 rebase. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    let blurEffect : UIBlurEffect = UIBlurEffect(style: .Dark)
    let backgroundView : UIVisualEffectView
    
    let foregroundContentView : UIView = UIView()
    let foregroundContentScrollView : UIScrollView = UIScrollView()
    
    let firstNameTextField : CNHFloatLabeledTextFieldView = CNHFloatLabeledTextFieldView(title: "First Name")
    let lastNameTextField : CNHFloatLabeledTextFieldView = CNHFloatLabeledTextFieldView(title: "Last Name")
    let emailTextField : CNHFloatLabeledTextFieldView = CNHFloatLabeledTextFieldView(title: "Email")
    let passwordTextField : CNHFloatLabeledTextFieldView = CNHFloatLabeledTextFieldView(title: "Password")
    let textFields : [CNHFloatLabeledTextFieldView]

    let signupButton : UIButton = UIButton.buttonWithType(.Custom) as UIButton
    let termsLabel : UILabel = UILabel()
    
    override init() {
        backgroundView = UIVisualEffectView(effect: blurEffect)
        textFields = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField]
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = true
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.shadowImage = UIImage()
//            navigationBar.shadowImage = self.imageWithColor(UIColor.darkGrayColor())
            navigationBar.tintColor = UIColor.whiteColor()
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        }
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("tappedClose:"))
        
        signupButton.backgroundColor = UIColor(red: 19/255, green: 173/255, blue: 163/255, alpha: 1)
        signupButton.setTitle("Create", forState: .Normal)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        signupButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        signupButton.layer.cornerRadius = 4
        signupButton.contentEdgeInsets = UIEdgeInsetsMake(7, 8 , 7, 8)
        signupButton.sizeToFit()
        signupButton.addTarget(self, action: Selector("didTapSignup"), forControlEvents: UIControlEvents.TouchUpInside)

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signupButton)
        
        view.addSubview(backgroundView)
        backgroundView.contentView.addSubview(foregroundContentScrollView)
        
        foregroundContentScrollView.addSubview(foregroundContentView)
        
        emailTextField.labeledTextField.keyboardType = .EmailAddress
        emailTextField.labeledTextField.autocapitalizationType = .None
        passwordTextField.labeledTextField.secureTextEntry = true
        passwordTextField.labeledTextField.returnKeyType = .Go

        for view in textFields {
            view.labeledTextField.delegate = self
            foregroundContentView.addSubview(view)
        }
        
        let termsText : String = "Terms of Use"
        let privacyText : String = "Privacy Policy"
        let termsAndPrivacyText : NSString = "By creating an account, you agree to Cinch's \(termsText) and \(privacyText)."
    
        var attribs : [NSObject : AnyObject] = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(11)]
        var attributedText : NSMutableAttributedString = NSMutableAttributedString(string: termsAndPrivacyText, attributes: attribs)
        var highlightAttribs : [NSObject : AnyObject] = [NSForegroundColorAttributeName : UIColor(red: 19/255, green: 173/255, blue: 163/255, alpha: 1)]
        
        attributedText.setAttributes(highlightAttribs, range: termsAndPrivacyText.rangeOfString(termsText, options: .LiteralSearch))
        attributedText.setAttributes(highlightAttribs, range: termsAndPrivacyText.rangeOfString(privacyText, options: .LiteralSearch))

        termsLabel.attributedText = attributedText
        termsLabel.numberOfLines = 0
        termsLabel.lineBreakMode = .ByWordWrapping
        termsLabel.font = UIFont.systemFontOfSize(11)
        foregroundContentView.addSubview(termsLabel)
        
        self.layoutSubviews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        firstNameTextField.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.becomeFirstResponder()
    }
    
    func layoutSubviews() {
        var superview : UIView = self.view
        
        backgroundView.mas_makeConstraints { (make) -> Void in
            make.edges.equalTo()(superview)
            return ()
        }
        
        foregroundContentScrollView.mas_makeConstraints { (make) -> Void in
            var topLayoutGuide : AnyObject = self.topLayoutGuide;
            
            if let topGuide = topLayoutGuide as? UIView {
                make.top.equalTo()(topGuide.mas_bottom);
                make.left.equalTo()(self.backgroundView)
                make.right.equalTo()(self.backgroundView)
                make.bottom.equalTo()(self.backgroundView)
            }
            
            return ()
        }
        
        foregroundContentView.mas_makeConstraints { (make) -> Void in
            var edge : CGFloat = 15
            var padding : UIEdgeInsets = UIEdgeInsetsMake(0, edge, 0, edge);
            make.edges.equalTo()(self.foregroundContentScrollView).with().insets()(padding)
            make.width.equalTo()(self.foregroundContentScrollView.mas_width).offset()(-padding.right * 2)
            return ()
        }
        
        self.generateTextFieldConstraints()
    }
    
    func generateTextFieldConstraints() {

        firstNameTextField.mas_makeConstraints { (make) in
            make.top.equalTo()(0)
            make.top.equalTo()(self.lastNameTextField.mas_top)
            make.left.equalTo()(0)
            make.right.equalTo()(self.lastNameTextField.mas_left).offset()(-10)
            make.width.equalTo()(self.lastNameTextField.mas_width)
            make.height.equalTo()(self.lastNameTextField.mas_height)
            make.height.greaterThanOrEqualTo()(44)

            return ()
        }
        
        lastNameTextField.mas_makeConstraints { (make) in
            make.top.equalTo()(self.firstNameTextField.mas_top)
            make.right.equalTo()(0)
            make.left.equalTo()(self.firstNameTextField.mas_right).offset()(10)
            make.width.equalTo()(self.firstNameTextField.mas_width)
            make.height.equalTo()(self.firstNameTextField.mas_height)
            make.height.greaterThanOrEqualTo()(44)
            
            return ()
        }

        var lastView : UIView = lastNameTextField
        
        for view in [emailTextField, passwordTextField] {
            view.mas_makeConstraints { (make) -> Void in
                make.top.equalTo()(lastView.mas_bottom).offset()(8)
                make.left.equalTo()(0)
                make.width.equalTo()(self.foregroundContentView.mas_width)
                make.height.greaterThanOrEqualTo()(44)
                
                return ()
            }
            
            lastView = view
        }
        
        termsLabel.mas_makeConstraints { (make) -> Void in
            make.top.equalTo()(lastView.mas_bottom).offset()(10)
            make.left.equalTo()(0)
            make.width.equalTo()(self.foregroundContentView.mas_width)
            
            return ()
        }
        
        foregroundContentView.mas_makeConstraints { (make) -> Void in
            make.bottom.equalTo()(self.termsLabel.mas_bottom)
            return ()
        }
    }
    
    func updateTextFieldConstraints() {
        for view in textFields {
            var height : CGFloat = 44
            
            if(view.state == CNHTextFieldControlState.Error) {
                height = 58
            }
            
            view.mas_updateConstraints { (make) -> Void in
                make.height.equalTo()(height)
                return ()
            }
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func tappedClose (sender : AnyObject) {
        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageWithColor(color : UIColor) -> UIImage {
        var rect : CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
    
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        return image;
    }
    
    func keyboardDidShow (notification : NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            foregroundContentScrollView.contentInset = contentInsets
            foregroundContentScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func keyboardWillBeHide (notification : NSNotification ) {
        var contentInsets : UIEdgeInsets = UIEdgeInsetsZero
        foregroundContentScrollView.contentInset = contentInsets
        foregroundContentScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        for view in textFields {
            if(view.labeledTextField == textField) {
                view.state = .Selected
            } else if(view.state != .Error) {
                view.state = .Normal
            }
        }
        
//        self.updateTextFieldConstraints()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == emailTextField.labeledTextField) {
            var validator : Validator = EmailValidator(input: textField.text)
            let (valid, err) = validator.validate()
            if(!valid) {
                emailTextField.state = .Error
                emailTextField.errorMessageLabel.text = err?.localizedDescription
            } else {
                emailTextField.state = .Normal
                emailTextField.errorMessageLabel.text = ""
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * 0)), dispatch_get_main_queue(), {
            self.updateTextFieldConstraints()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        for (index, view) in enumerate(textFields) {
            if (view.labeledTextField == textField && (textFields.count > index + 1)) {
                
                if let nextView = self.textFields[index + 1] as UIView? {
                    nextView.becomeFirstResponder()
                }
            }
        }
        
        return false
    }
    
    // MARK: Actions
    func didTapSignup() {
        var vc : VerifyPhoneViewController = VerifyPhoneViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}