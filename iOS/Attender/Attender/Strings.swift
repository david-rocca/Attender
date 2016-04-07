//
//  Strings.swift
//  Attender
//
//  Created by David Rocca on 4/5/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import Foundation


class Strings {
    private static let appName = "Attender";
    
    
    static func AppName() -> String {
        return appName;
    }
    
    static func NetType() -> String {
        return NetStrings.NType();
    }
    
    static func NetRocca() -> String {
        return NetStrings.Rocca();
    }
    
    static func NetUname() -> String {
        return NetStrings.Uname();
    }
    
    static func NetEmail() -> String {
        return NetStrings.Email();
    }
    
    static func NetMethod() -> String {
        return NetStrings.Method();
    }
    
    static func NetLoginUser() -> String {
        return NetStrings.LogIn()
    }
    
    static func NetPassword() -> String {
        return NetStrings.Password();
    }
    
    static func NetCreateUser() -> String {
        return NetStrings.CreateUser();
    }
    
    static func NetCreateSession() -> String {
        return NetStrings.CreateSession();
    }
    
    
    
}



class NetStrings {
    private static let netType = "type";
    private static let netRocca = "rocca";
    private static let netUname = "uname";
    private static let netEmail = "email";
    private static let netMethod = "method";
    private static let netLoginUser = "logIn";
    private static let netPassword = "password";
    private static let netCreateUser = "createUser";
    private static let netCreateSession = "createSession";
    
    
    static func NType() -> String {
        return netType;
    }
    
    static func Rocca() -> String {
        return netRocca;
    }
    
    static func Uname() -> String {
        return netUname;
    }
    
    static func Email() -> String {
        return netEmail;
    }
    
    static func Method() -> String {
        return netMethod;
    }
    
    static func LogIn() -> String {
        return netLoginUser;
    }
    
    static func Password() -> String {
        return netPassword;
    }
    
    static func CreateUser() -> String {
        return netCreateUser;
    }
    
    static func CreateSession() -> String {
        return netCreateSession;
    }
    
}