//
//  Users.swift
//  Attender
//
//  Created by David Rocca on 4/13/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import Foundation
import CoreLocation

class Users {
    
    private var email: String = "";
    private var location: CLLocation?;

    
    init(email: String) {
        self.email = email;
        self.location = nil;
    }
    
    init(email: String, withLocation location: CLLocation) {
        self.email = email;
        self.location = location;
    }
    
    func getEmail() -> String{
        return self.email;
    }
    
    func getLocation() -> CLLocation {
        return self.location!;
    }
    
    func setLocation(location: CLLocation) {
        self.location = location;
    }
    
}