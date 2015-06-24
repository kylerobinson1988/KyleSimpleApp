//
//  NotesTableViewController.swift
//  CoreNotes
//
//  Created by Kyle Brooks Robinson on 6/23/15.
//  Copyright (c) 2015 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import CoreData

// 3

// Fetch all categories (set a local array to returned objects)
// Per category, fetch Notes that have the category.

// Add a section title based on category name.

class NotesTableViewController: UITableViewController {
    
    // Category Color : [Notes]
    
    var categoryNotes: [String:[NSManagedObject]] = [:]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let moc = appDelegate.managedObjectContext {
            
            let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: moc)
            
            let request = NSFetchRequest()
            
            request.entity = entity
            
            if let objects = moc.executeFetchRequest(request, error: nil) as? [NSManagedObject] {
                
                for catObject in objects {
                    
                    let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: moc)
                    
                    let request = NSFetchRequest()
                    
                    request.entity = entity
                    
                    // add predicate filter for category
                    
//                    let predicate = NSPredicate(format: "%K contains %@", "Key", "category")
                    
//                    request.predicate = predicate
                    
                    let predicate = NSPredicate(format: "%K contains %@", "category", "String")
                    
                    request.predicate = predicate
                        
                    
                    
                    if let objects = moc.executeFetchRequest(request, error: nil) as? [NSManagedObject] {
                        
                        categoryNotes[catObject.valueForKey("color") as! String] = objects
                        tableView.reloadData()

                    }
                    
                }
                    
            }
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let categoryName = categoryNotes.keys.array[section]
        
        let color = categoryColor(categoryName)
        
        let header = UIView()
        
        header.backgroundColor = color
        
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        
        label.text = categories[categoryName]!.0
        label.font = UIFont.systemFontOfSize(14)
        
        header.addSubview(label)
        
        return header
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return categoryNotes.keys.array.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        let categoryName = categoryNotes.keys.array[section]
        
        return categoryNotes[categoryName]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! UITableViewCell

        let categoryName = categoryNotes.keys.array[indexPath.section]
        
        let note = categoryNotes[categoryName]![indexPath.row]

        
        cell.textLabel?.text = note.valueForKey("content") as? String
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            let categoryName = categoryNotes.keys.array[indexPath.section]
            
            let note = categoryNotes[categoryName]![indexPath.row]
            
            appDelegate.managedObjectContext?.deleteObject(note)
            appDelegate.saveContext()
            
            categoryNotes[categoryName]!.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
