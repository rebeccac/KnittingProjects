//
//  ProjectViewController.swift
//  KnittingProjects
//
//  Created by Rebecca Cordingley on 7/07/2014.
//  Copyright (c) 2014 Rebecca Cordingley. All rights reserved.
//

import UIKit
import CoreData
class ProjectViewController: UIViewController {

    var input: UITextField = UITextField()
    var alert = UIAlertView()
    
    
    var name: String = ""
    var notes: String = ""
    var counter: Int = 0
    var existingItem: NSManagedObject!
    
    @IBOutlet var projectNameLabel: UILabel
    @IBOutlet var notesTextField: UITextView
    @IBOutlet var counterLabel: UILabel
    
    
    func getContext()->NSManagedObjectContext {
        // Reference to our app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        // Reference managed object context
        let context: NSManagedObjectContext = appDel.managedObjectContext
        return context
    }
    
    func getEntity(context:NSManagedObjectContext)->NSEntityDescription {
        let entity = NSEntityDescription.entityForName("Projects", inManagedObjectContext: context)
        return entity
    }
    
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 0:
            projectNameLabel.text = input.text
            
            // Save project to DB:
            let context = getContext()
            let entity = getEntity(context)
            
            // Create instance of data model and initialise
            var newItem = Model(entity: entity, insertIntoManagedObjectContext: context)
            
            // Map properties
            newItem.name = projectNameLabel.text
            newItem.notes = ""
            newItem.counter = 0
            
            // save newItem to existingItem var
            existingItem = newItem
            // Save context
            context.save(nil)
            
        default:
            println("Other button")
        }
    }
    
    
    @IBAction func increaseCounterPressed(sender: AnyObject) {
        counter++
        counterLabel.text = "\(counter)"
        
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counter as Int, forKey: "counter")
        }

    }
    
    @IBAction func decreaseCounterPressed(sender: AnyObject) {
        if counter > 0 {
            counter--
            counterLabel.text = "\(counter)"
            
            let context = getContext()
            let entity = getEntity(context)
            
            // save counter's value to DB
            if existingItem {
                existingItem.setValue(counter as Int, forKey: "counter")
            }
        }
    }
   
    @IBAction func resetCounterPressed(sender: AnyObject) {
        counter = 0
        counterLabel.text = "\(counter)"
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counter as Int, forKey: "counter")
        }
        
    }
    func textView(_textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
            
            // If Return (Done) key is pressed, resign keyboard & save notes
            if text == "\n" {
                notesTextField.resignFirstResponder()
                
                let context = getContext()
                let entity = getEntity(context)
                
                // save notes to DB
                if existingItem {
                    existingItem.setValue(notesTextField.text as String, forKey: "notes")
                }
                
            }
            return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set UITextView's border
        notesTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        notesTextField.layer.borderWidth = 1.0
        
        if existingItem {
            projectNameLabel.text = name
            notesTextField.text = notes
            counterLabel.text = "\(counter)"
        } else {
            // If creating a new project, display UIAlertView
            alert.delegate = self
            alert.title = "Enter Project's Name"
            alert.addButtonWithTitle("Save")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            input = alert.textFieldAtIndex(0)
            // Set auto-capitalisation of input field - each word capitalised
            input.autocapitalizationType = UITextAutocapitalizationType.Words
            input.placeholder = "Enter project's name"
            alert.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
