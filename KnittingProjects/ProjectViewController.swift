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
    var counterOne: Int = 0
    var counterTwo: Int = 0
    var existingItem: NSManagedObject!
    
    @IBOutlet var projectNameLabel: UILabel
    @IBOutlet var notesTextField: UITextView
    @IBOutlet var counterOneLabel: UILabel
    @IBOutlet var counterTwoLabel: UILabel
    
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
            newItem.counterOne = 0
            newItem.counterTwo = 0
            
            // save newItem to existingItem var
            existingItem = newItem
            // Save context
            context.save(nil)
            
        default:
            println("Other button")
        }
    }
    
    
    @IBAction func increaseCounterOnePressed(sender: AnyObject) {
        counterOne++
        counterOneLabel.text = "\(counterOne)"
        
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counterOne as Int, forKey: "counterOne")
            context.save(nil)
        }
    }
    
    @IBAction func increaseCounterTwoPressed(sender: AnyObject) {
        counterTwo++
        counterTwoLabel.text = "\(counterTwo)"
        
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counterTwo as Int, forKey: "counterTwo")
            context.save(nil)
        }
    }
    
    @IBAction func decreaseCounterOnePressed(sender: AnyObject) {
        if counterOne > 0 {
            counterOne--
            counterOneLabel.text = "\(counterOne)"
            
            let context = getContext()
            let entity = getEntity(context)
            
            // save counter's value to DB
            if existingItem {
                existingItem.setValue(counterOne as Int, forKey: "counterOne")
                context.save(nil)
            }
        }
    }
    
    @IBAction func decreaseCounterTwoPressed(sender: AnyObject) {
        if counterTwo > 0 {
            counterTwo--
            counterTwoLabel.text = "\(counterTwo)"
            
            let context = getContext()
            let entity = getEntity(context)
            
            // save counter's value to DB
            if existingItem {
                existingItem.setValue(counterTwo as Int, forKey: "counterTwo")
                context.save(nil)
            }
        }
    }
   
    @IBAction func resetCounterOnePressed(sender: AnyObject) {
        counterOne = 0
        counterOneLabel.text = "\(counterOne)"
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counterOne as Int, forKey: "counterOne")
            context.save(nil)
        }
        
    }
    
    @IBAction func resetCounterTwoPressed(sender: AnyObject) {
        counterTwo = 0
        counterTwoLabel.text = "\(counterTwo)"
        let context = getContext()
        let entity = getEntity(context)
        
        // save counter's value to DB
        if existingItem {
            existingItem.setValue(counterTwo as Int, forKey: "counterTwo")
            context.save(nil)
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
                    context.save(nil)
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
            counterOneLabel.text = "\(counterOne)"
            counterTwoLabel.text = "\(counterTwo)"
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
}
