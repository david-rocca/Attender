//
//  Networking.swift
//  Attender
//
//  Created by David Rocca on 3/30/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import Foundation

protocol NetworkReceiver {
    func networkError(error:NSError, source:NSURL) -> Void;
    func jsonResponse(data:NSDictionary, source:NSURL) -> Void;
}

class Network {
    
    private static var highlander: Network?;
    private var delegate:NetworkReceiver?;
    private static var host:NSString = "http://146.115.94.121:8010/"
    init() {
        print("Init called.", terminator: "");
    }
    
    static func startup() {
        if highlander == nil {
            highlander = Network();
        }
    }
    
    static func shutdown() {
        highlander = nil;
    }
    
    static private func httpRequestFromUrl(url:String, args:NSDictionary?, cb:(d:NSData, s:NSURL, e:NSError?) -> Void) -> Bool{
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: config, delegate: nil, delegateQueue:NSOperationQueue.mainQueue());
        let req:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!);
        if args != nil {
            req.HTTPMethod = "POST";
            let postString: NSMutableString = NSMutableString();
            
            for (key, _) in args! {
                postString.appendFormat("%@=%@&", key as! NSString, args!.objectForKey(key)as! NSString);
            }
            req.HTTPBody = postString.substringToIndex(postString.length - 1).dataUsingEncoding(NSUTF8StringEncoding);
            
        }
        
        
        let task:NSURLSessionDataTask? = session.dataTaskWithRequest(req,
                                                                     completionHandler: {
                                                                        (data, response, error) -> Void in
                                                                        cb(d: data!, s: req.URL!, e: error);
        });
        
        
        if task != nil {
            task?.resume();
        }
        
        return task != nil;
    }
    
    
    static func jsonRequestFromURL(url:NSString, receiver:NetworkReceiver) -> Bool {
        return Network.jsonRequesFromUrlWithArgs(url, args: nil, receiver: receiver);
        
    }
    
    static func jsonRequesFromUrlWithArgs(url:NSString, args:NSDictionary?, receiver:NetworkReceiver) -> Bool{
        return Network.httpRequestFromUrl(url as String, args: args, cb: { (d, s, e) -> Void in
            print("Returned", terminator: "");
            if e != nil {
                receiver.networkError(e!, source: s);
            } else {
                let err:NSError? = nil;
                var jsonDict:NSDictionary = NSDictionary();
                jsonDict = (try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary;
                
                if err != nil {
                    receiver.networkError(err!, source: s);
                }
                
                receiver.jsonResponse(jsonDict, source: s);
                
            }
            
        })
    }
    
    static func test(receiver:NetworkReceiver) -> Bool{
        //let finalUrl:NSString = host.stringByAppendingString("test.php");
        let data:NSMutableDictionary = NSMutableDictionary();
        
        data.setValue("rocca", forKey:"type");
        data.setValue("createUser", forKey: "method");
        data.setValue("test", forKey: "params");
        
        return Network.jsonRequesFromUrlWithArgs(host, args: data, receiver: receiver);
    }
    
}