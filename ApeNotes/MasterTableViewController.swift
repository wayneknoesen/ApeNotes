//
//  MasterTableViewController.swift
//  ApeNotes
//
//  Created by Wayne Knoesen on 14/02/15.
//  Copyright (c) 2015 LeetApps. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    var noteObjects: NSMutableArray! = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            var loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            loginViewController.signUpController = signUpViewController
            self.presentViewController(loginViewController, animated: true, completion: nil)
            
        } else {
            
            self.fetchallObjectsFromLocalDataStore()
            self.fetchAllObjects()
            
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
        
    }
    
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to log in... ")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        if let password = info?["password"] as? String {
            return password.utf16Count >= 8
        } else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        println("failed to Sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        println("USer dismissed sign up")
    }
    
    

    func fetchallObjectsFromLocalDataStore () {
        
        var query: PFQuery = PFQuery(className: "Note")
        
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                var temp: NSArray = objects as NSArray
                
                self.noteObjects = temp.mutableCopy() as NSMutableArray
                
                self.tableView.reloadData()
                
            }else {
                println(error.userInfo)
            }
        }
        
    }
    
    func fetchAllObjects() {
        
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query: PFQuery = PFQuery(className: "Note")
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil) {
                
                PFObject.pinAllInBackground(objects, block: nil)
                
                self.fetchallObjectsFromLocalDataStore()
                
            }else{
                println(error.userInfo)
            }

        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.noteObjects.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as MasterUTableViewCell

        var object: PFObject = self.noteObjects.objectAtIndex(indexPath.row) as PFObject
        cell.masterTitleLable?.text = object["title"] as? String
        cell.masterTextLabel?.text = object["text"] as? String

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("editNote", sender: self)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var upcoming: AddNoteTableViewController = segue.destinationViewController as AddNoteTableViewController
        
        if (segue.identifier == "editNote") {
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            var object: PFObject = self.noteObjects.objectAtIndex(indexPath.row) as PFObject
            upcoming.object = object;
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }


}
