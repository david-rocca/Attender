//
//  ManageSession.swift
//  Attender
//
//  Created by David Rocca on 4/13/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit


class ManageSession : UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkReceiver{
    
    @IBOutlet weak var tableSessionMembers: UITableView!
    var refreshControl = UIRefreshControl();
    
    let textCellIdentifier = "myCell";
    var sessionNumber: Int = 0;
    
    
    var owner: Users?;
    var currentUsers = [Users]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableSessionMembers.delegate = self;
        self.tableSessionMembers.dataSource = self;

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationItem.title = String(self.sessionNumber);    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
    //MARK: Table View Delegate Functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableSessionMembers.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath);
        let row = indexPath.row;
        cell.textLabel?.text = currentUsers[row].getEmail();
        
        return cell;
    }
    
    //MARK: Networking Fucntions
    
    func jsonResponse(data: NSDictionary, source: NSURL) {
        
    }
    
    func networkError(error: NSError, source: NSURL) {
        
    }
    
}
