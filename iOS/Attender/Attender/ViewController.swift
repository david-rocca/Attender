//
//  ViewController.swift
//  Attender
//
//  Created by David Rocca on 3/30/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, NetworkReceiver {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var viewContentFrame: UIView!
    
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var constraintLoginTwoHeight: NSLayoutConstraint!
   
    @IBOutlet weak var textEmailSignUp: UITextField!
    @IBOutlet weak var labelSignUp: UILabel!
    @IBOutlet weak var btnDontHaveAccount: UIButton!
    @IBOutlet weak var btnLoginTwo: UIButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var scrollMainScrollView: UIScrollView!
    @IBOutlet weak var textConfirmPasswordSignUp: UITextField!
    @IBOutlet weak var btnHaveAccount: UIButton!
    
    @IBOutlet weak var textPasswordSignUp: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    var activeTextField: UITextField?;
    var tap: UITapGestureRecognizer?;
    
    var isFirstTouch = true;
    var isLoginTouched = true;
    var isKeyboardUp = false;
    
    //MARK: LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Network.startup();
        
        self.registerForKeyboardNotifications();
        self.scrollMainScrollView.scrollEnabled = false;
        
        btnLogin.layer.cornerRadius = 4;
        btnSignUp.layer.cornerRadius = 4;
        btnLoginTwo.layer.cornerRadius = 4;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.textEmail.delegate = self;
        self.textPassword.delegate = self;
        self.textEmailSignUp.delegate = self;
        self.textPasswordSignUp.delegate = self;
        self.textConfirmPasswordSignUp.delegate = self;
        
        self.textEmail.hidden = true;
        self.textPassword.hidden = true;
        self.textEmailSignUp.hidden = true;
        self.textPasswordSignUp.hidden = true;
        self.textConfirmPasswordSignUp.hidden = true;
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        //self.unregisterForKeyboardNotifications();
    
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Buttion Actions
    
    @IBAction func btnHaveAccountPressed(sender: AnyObject) {
        self.isLoginTouched = true;
        
        if (self.isKeyboardUp == true) {
            self.btnLogin.frame = self.btnSignUp.frame;
        } else if (self.isKeyboardUp == false) {
            self.btnLogin.frame = self.btnLoginTwo.frame;
        } else {
            print("bad");
        }
        
        
        UIView.animateWithDuration(0.7) {
            self.btnHaveAccount.hidden = true;
            self.textEmailSignUp.hidden = true;
            self.textPasswordSignUp.hidden = true;
            self.textConfirmPasswordSignUp.hidden = true;
            self.labelSignUp.hidden = true;
            self.btnSignUp.hidden = true;
            
            
            self.textEmail.hidden = false;
            self.textPassword.hidden = false;
            self.btnDontHaveAccount.hidden = false;
            self.labelLogin.hidden = false;
            self.btnLogin.hidden = false;
        }
        
    }
    
    
    @IBAction func btnDontHaveAccountPressed(sender: AnyObject) {
        self.isLoginTouched = false;
        
        if (self.isKeyboardUp == true) {
            self.btnSignUp.frame = self.btnLogin.frame;
        } else if (self.isKeyboardUp == false) {
            self.btnSignUp.frame = self.btnLoginTwo.frame;
        } else {
            print("bad");
        }

        
        UIView.animateWithDuration(0.7) {
            self.textEmail.hidden = true;
            self.textPassword.hidden = true;
            self.btnDontHaveAccount.hidden = true;
            self.labelLogin.hidden = true;
            self.btnLogin.hidden = true;
            
            
            self.btnHaveAccount.hidden = false;
            self.textEmailSignUp.hidden = false;
            self.textPasswordSignUp.hidden = false;
            self.textConfirmPasswordSignUp.hidden = false;
            self.labelSignUp.hidden = false;
            self.btnSignUp.hidden = false;
            
        }
        
        
    }
    
    @IBAction func btnSignUpPressed(sender: AnyObject) {
        if (isFirstTouch == true) {
            isLoginTouched = false;
            let difference = self.imgHeader.frame.height * 0.75;
            let logoDifferenceWidth = self.imgLogo.frame.width * 0.50;
            let logoDifferenceHeight = self.imgLogo.frame.height * 0.50;
            
            UIView.animateWithDuration(0.7) {
                self.btnLogin.hidden = true;
                self.labelSignUp.hidden = false;
                self.textEmailSignUp.hidden = false;
                self.textPasswordSignUp.hidden = false;
                self.textConfirmPasswordSignUp.hidden = false;
                self.btnHaveAccount.hidden = false;
                
                
                self.imgHeader.frame = CGRectMake(self.imgHeader.frame.origin.x, self.imgHeader.frame.origin.y, self.imgHeader.frame.width, (self.imgHeader.frame.height - difference));
                self.imgLogo.frame = CGRectMake((self.viewContentFrame.frame.size.width / 2) - (self.imgLogo.frame.width - logoDifferenceWidth) * (1/2), (self.imgHeader.frame.height), (self.imgLogo.frame.width - logoDifferenceWidth), (self.imgLogo.frame.height - logoDifferenceHeight));
                
                
                let frame = self.btnLoginTwo.frame;
                self.btnSignUp.frame = frame;
                self.isFirstTouch = false;
            }
        } else {
            print("Sign Up Called");
            Network.createUser(self.textEmailSignUp.text!, password: self.textPasswordSignUp.text!, uname: self.textEmailSignUp.text!, receiver: self);
        }
    }
    
    
    @IBAction func btnLoginPressed(sender: AnyObject) {
        
        if (isFirstTouch == true) {
            let difference = self.imgHeader.frame.height * 0.75;
            let logoDifferenceWidth = self.imgLogo.frame.width * 0.50;
            let logoDifferenceHeight = self.imgLogo.frame.height * 0.50;
            
            UIView.animateWithDuration(0.7) {
                self.labelLogin.hidden = false;
                self.textEmail.hidden = false;
                self.textPassword.hidden = false;
                self.btnSignUp.hidden = true;
                self.btnDontHaveAccount.hidden = false;
                //self.btnLogin.hidden = true;
                //self.btnLoginTwo.hidden = false;
                
                self.imgHeader.frame = CGRectMake(self.imgHeader.frame.origin.x, self.imgHeader.frame.origin.y, self.imgHeader.frame.width, (self.imgHeader.frame.height - difference));
                self.imgLogo.frame = CGRectMake((self.viewContentFrame.frame.size.width / 2) - (self.imgLogo.frame.width - logoDifferenceWidth) * (1/2), (self.imgHeader.frame.height), (self.imgLogo.frame.width - logoDifferenceWidth), (self.imgLogo.frame.height - logoDifferenceHeight));
                
                
                let frame = self.btnLoginTwo.frame;
                self.btnLogin.frame = frame;
                self.isFirstTouch = false;
            }
        } else {
            print("Login Called");
            
            /*
                Normally I would but in test cases here but I am lazy
             */
            
            Network.loginUser(self.textEmail.text!, password: self.textPassword.text!, receiver: self);
            
            
            
        }
        
        
    }
    
    
    //MARK: Network Functions
    
    func networkError(error: NSError, source: NSURL) {
        
    }
    
    func jsonResponse(data: NSDictionary, source: NSURL) {
        let success = data["response"] as! String;
        
        if (success == "success") {
            print("Segue Success");
            performSegueWithIdentifier("toMainArea", sender: self);
            
        }
        
    }

    
    //MARK: Keyboard
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter();
        self.tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.resignKeyboard));
        
        view.addGestureRecognizer(tap!);
        
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil);
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil);
    }
    
    
    func unregisterForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter();
        view.removeGestureRecognizer(tap!);
        notificationCenter.removeObserver(self);
        
        print(notificationCenter);
        
    }
    
    
    func resignKeyboard() {
        view.endEditing(true);
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        self.isKeyboardUp = true;
        let info: NSDictionary = sender.userInfo!;
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size;

        
        if (isLoginTouched == true) {
            var frame = self.btnLogin.frame;
            if (frame.origin.y == self.btnLoginTwo.frame.origin.y) {
                UIView.animateWithDuration(0.4) {
                    frame.origin.y -= keyboardSize!.height;
                    self.btnLogin.frame = frame;
                }
                
            }
        } else {
            var frame = self.btnSignUp.frame;
            if (frame.origin.y == self.btnLoginTwo.frame.origin.y) {
                UIView.animateWithDuration(0.4) {
                    frame.origin.y -= keyboardSize!.height;
                    self.btnSignUp.frame = frame;
                }
                
            }

        }
        
        
        
       
        print("ViewController: Keyboard shown");
        
    }
    
    func keyboardWillBeHidden(sender: NSNotification) {
        self.isKeyboardUp = false;
        let info: NSDictionary = sender.userInfo!;
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size;
        
        
        
        if (isLoginTouched == true) {
            UIView.animateWithDuration(0.4) {
                var frame = self.btnLogin.frame;
                frame.origin.y += keyboardSize!.height;
                self.btnLogin.frame = frame;
            }
        } else {
            UIView.animateWithDuration(0.4) {
                var frame = self.btnSignUp.frame;
                frame.origin.y += keyboardSize!.height;
                self.btnSignUp.frame = frame;
            }
        }
        

        
        
        print("ViewController: Keyboard Hidden");
        
    }
    
    //MARK: UITextField Delegates
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField;
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        activeTextField = nil;
        return true;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.unregisterForKeyboardNotifications();
    }
    
}

	