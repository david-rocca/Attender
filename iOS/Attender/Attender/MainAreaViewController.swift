//
//  MainAreaViewController.swift
//  Attender
//
//  Created by David Rocca on 4/7/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit
import CoreLocation

class MainAreaViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var textSessionNumber: UITextField!
    var tap: UITapGestureRecognizer?;
    
    let locationManager = CLLocationManager();
    override func viewDidLoad() {
        super.viewDidLoad();
        locationManager.requestWhenInUseAuthorization();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.tap = UITapGestureRecognizer(target: self, action: #selector(MainAreaViewController.resignKeyboard));
        view.addGestureRecognizer(tap!);
        //locationManager.requestLocation();
    }
    
    func resignKeyboard() {
        print("MainAreaViewController: Resign Keyboard");
        view.endEditing(true);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.textSessionNumber.delegate = self;
        self.registerForKeyboardNotifications();
        
        
        super.viewWillAppear(animated);
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                print("No access")
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        //view.removeGestureRecognizer(tap!);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    //MARK: ButtonPresses
    
    
    @IBAction func btnCreateSessionPressed(sender: AnyObject) {
    }
    
    @IBAction func btnJoinSessionPressed(sender: AnyObject) {
    }
    
    //MARK: Location Management Functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error);
    }
    
    //MARK: Text Field Delegate Functions
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 6
    }
    
    
    
    //MARK: Keyboard
    
    //MARK: Keyboard
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter();
        self.tap = UITapGestureRecognizer(target: self, action: #selector(MainAreaViewController.resignKeyboard));
        
        view.addGestureRecognizer(tap!);
        
        notificationCenter.addObserver(self, selector: #selector(MainAreaViewController.keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil);
        notificationCenter.addObserver(self, selector: #selector(MainAreaViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil);
    }
    
    
    func unregisterForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter();
        view.removeGestureRecognizer(tap!);
        notificationCenter.removeObserver(self, name: "keyboardWillBeShown:", object: nil);
        notificationCenter.removeObserver(self, name: "keyboardWillBeHidden:", object: nil);
        print(notificationCenter);
        
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        print("Main Area: Keyboard shown");
        
    }
    
    func keyboardWillBeHidden(sender: NSNotification) {
        print("Main Area: Keyboard Hidden");
        
    }

}
