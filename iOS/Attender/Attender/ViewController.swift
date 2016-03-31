//
//  ViewController.swift
//  Attender
//
//  Created by David Rocca on 3/30/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkReceiver {

    override func viewDidLoad() {
        super.viewDidLoad()
        Network.startup();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkError(error: NSError, source: NSURL) {

    }
    
    func jsonResponse(data: NSDictionary, source: NSURL) {
        for (key,value) in data {
            print("\(key) = \(value)");
        }
    }

    @IBAction func testNetwork(sender: AnyObject) {
        Network.test(self);
    }
}

	