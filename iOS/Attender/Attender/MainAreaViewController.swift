//
//  MainAreaViewController.swift
//  Attender
//
//  Created by David Rocca on 4/7/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit
import CoreLocation

class MainAreaViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, NetworkReceiver{
    @IBOutlet weak var textSessionNumber: UITextField!
    var tap: UITapGestureRecognizer?;
    var location: CLLocation?;
    var randomNumber: Int = 0; 
    let locationManager = CLLocationManager();
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        locationManager.requestWhenInUseAuthorization();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.tap = UITapGestureRecognizer(target: self, action: #selector(MainAreaViewController.resignKeyboard));
        view.addGestureRecognizer(tap!);
        locationManager.requestLocation();
    }
    
    func resignKeyboard() {
        print("MainAreaViewController: Resign Keyboard");
        view.endEditing(true);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.textSessionNumber.delegate = self;
        self.registerForKeyboardNotifications();
        self.navigationItem.title = "Sessions"
        
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
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
        self.unregisterForKeyboardNotifications();
        
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
        if (self.location == nil) {
            print("Location Not stored");
        } else {
            
            Network.createSession(withEmail: "a", withLat: String(self.location!.coordinate.latitude), withLong: String(self.location!.coordinate.longitude), withReceiver: self);
        }
        
        
        
    }
    
    @IBAction func btnJoinSessionPressed(sender: AnyObject) {
        if (self.location == nil) {
            print("Location Not stored");
        } else {
            
            Network.joinSession(withEmail: "b", withSessionNumber: self.textSessionNumber.text!, withLat: String(self.location!.coordinate.latitude), withLong: String(self.location!.coordinate.longitude), withReceiver: self);

        }
        
    }
    
    //MARK: Location Management Functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            self.location = locations.first!;
            print("current Location Latitude: \(locations.first!.coordinate.latitude)");
            print("current Location Longitute: \(locations.first!.coordinate.longitude)");
            
        } else {
            print("BAD");
        }
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
        notificationCenter.removeObserver(self);
        print(notificationCenter);
        
    }
    
    func keyboardWillBeShown(sender: NSNotification) {
        print("Main Area: Keyboard shown");
        
    }
    
    func keyboardWillBeHidden(sender: NSNotification) {
        print("Main Area: Keyboard Hidden");
        
    }
    
    //MARK: Network Responders
    
    func jsonResponse(data: NSDictionary, source: NSURL) {
        print(data);
        if (data["response"] as! String == "success") {
            if (data["method"] as! String == "createSession") {
                self.randomNumber = Int(data["data"] as! String)!;
                performSegueWithIdentifier("toManageSession", sender: self);
            } else if (data["method"] as! String == "joingSession") {
                print("Joining Session");
            }
        }
    }
    
    func networkError(error: NSError, source: NSURL) {
    }
    
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationItem.title = "Cancel";
        let owner: Users = Users(email: "b", withLocation: self.location!);
        let tempView = segue.destinationViewController as! ManageSession;
        tempView.sessionNumber = self.randomNumber;
        tempView.owner = owner;
    }

}
