//
//  ViewController.swift
//  KnittingProjects
//
//  Created by Rebecca Cordingley on 7/07/2014.
//  Copyright (c) 2014 Rebecca Cordingley. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myList:Array<AnyObject> = []
    
    
    @IBOutlet var tableView: UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = UIColor(red: 19.0/255.0, green: 100.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        tableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Reference to our app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // Reference managed object context
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        // Fetch data from entity "List"
        let freq = NSFetchRequest(entityName: "Projects")
        
        // Save data in myList array
        myList = context.executeFetchRequest(freq, error: nil)
        
        // Reload TableView
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "project" {
            // save NSManagedObject from selected tableView cell to selectedItem var
            var selectedItem: NSManagedObject = myList[self.tableView.indexPathForSelectedRow().row] as NSManagedObject
            
            // create segue to instance of ProjectViewController (IVC)
            let PVC: ProjectViewController = segue.destinationViewController as ProjectViewController
            
            // pass data to ProjectViewController
            PVC.name = selectedItem.valueForKey("name") as String
            PVC.notes = selectedItem.valueForKey("notes") as String
            // get int value from DB - if object is nil, set to 0, else cast to Int
            var count1 : AnyObject! = selectedItem.valueForKey("counterOne")
            if count1 == nil {
                PVC.counterOne = 0
            }
            else {
                PVC.counterOne = count1 as Int
            }
            
            var count2: AnyObject! = selectedItem.valueForKey("counterTwo")
            if count2 == nil {
                PVC.counterTwo = 0
            } else {
                PVC.counterTwo = count2 as Int
            }
            // register existing item to NSManagedObject existingItem variable in ProjectViewController
            // tells ProjectViewController which item is being modified in DB
            PVC.existingItem = selectedItem
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myList.count
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
        // "Cell" must match cell identifier given to cell in storyboard TableView
        let CellID: NSString = "Cell"
        
        var cell: UITableViewCell = tableView?.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        
        //cell.backgroundColor = UIColor.darkGrayColor()
        cell.textColor = UIColor.whiteColor()
        
        
        
        if let ip = indexPath {
            var data: NSManagedObject = myList[ip.row] as NSManagedObject
            var projectName: String = data.valueForKey("name") as String
            var projectNumber: Int = ip.row + 1
            
            
            if ip.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 18.0/255.0, green: 120.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 26.0/255.0, green: 139.0/255.0, blue: 179.0/255.0, alpha: 1.0)
            }
            
            
            
            cell.textLabel.text = "Project \(projectNumber): \(projectName)"
        }
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        
        // Reference to our app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        // Reference managed object context
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        // if deleting an item, will execute code in if-statement
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = tableView {
                // delete object from DB
                context.deleteObject(myList[indexPath!.row] as NSManagedObject)
                // update data source at indexPath
                myList.removeAtIndex(indexPath!.row)
                // update tableView
                tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            // if anything goes wrong with deletion process, abort - prevents app from crashing
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }
}

