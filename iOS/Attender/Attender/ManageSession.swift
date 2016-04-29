//
//  ManageSession.swift
//  Attender
//
//  Created by David Rocca on 4/13/16.
//  Copyright © 2016 David Rocca. All rights reserved.
//

import UIKit


class ManageSession : UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkReceiver{
    
    //local variables
    var refreshControl = UIRefreshControl();
    @IBOutlet weak var tableSessionMembers: UITableView!
    let textCellIdentifier = "myCell";
    var sessionNumber: Int = 0;
    
    
    var owner: Users?;
    var currentUsers = [Users]();
    
    
    
    override func viewDidLoad() {
        //Prepare table delegates
        super.viewDidLoad();
        self.tableSessionMembers.delegate = self;
        self.tableSessionMembers.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh");
        
        self.refreshControl.addTarget(self, action: #selector(ManageSession.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged);
        self.tableSessionMembers?.addSubview(refreshControl);
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationItem.title = String(self.sessionNumber);    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
    //Pull to refresh
    func refresh(sender: AnyObject) {
        self.getData();
    }
    
    func getData() {
        //Get users
        Network.getUsersInSession(withSessionNumber: String(self.sessionNumber), withReceiver: self);
    }
    
    
    //MARK: Table View Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count;
    }
    
    
    //Cell generation functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableSessionMembers.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath);
        let row = indexPath.row;
        cell.textLabel?.text = currentUsers[row].getEmail();
        cell.detailTextLabel?.text = "Detail Text Label";
        cell.imageView?.image = UIImage(named: "myFakeLogo");
        
        return cell;
    }
    
    
    
    //MARK: Networking Fucntions
    
    
    //Network response
    func jsonResponse(data: NSDictionary, source: NSURL) {
        if (self.refreshControl.refreshing == true) {
            self.refreshControl.endRefreshing();
        }
        
        let usersInSession = data.valueForKey("data");
        
        currentUsers.removeAll();
        for tempUser in usersInSession as! NSArray{
            let addingUser: Users = Users(email: tempUser.valueForKey("uname")! as! String)
            currentUsers.append(addingUser);
        }
       
        self.tableSessionMembers.reloadData();
        
    }
    
    func networkError(error: NSError, source: NSURL) {
        
    }
    
}
