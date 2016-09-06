//
//  TableViewController.swift
//  MemeApp
//
//  Created by Terrence Kuo on 4/6/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

import Foundation
import UIKit

// inherit the classes to be a delegate of the UIImagePickerController
class TableViewController: UITableViewController{
    
    //**************************
    // Private Variables
    //**************************

    // obtain array of Meme from persistent storage
    var memes: MemeArray = MemeArray()
    var imageStore: ImageStore = ImageStore()

    
    //**************************
    // Life Cycle Methods
    //**************************
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //**************************
    // Table Methods
    //**************************

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.allMemes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // obtain the meme image that was selected
        let meme = self.memes.allMemes[indexPath.row]
        
        // create ActivityViewController, passing the memeImage to it
        let controller = UIActivityViewController(activityItems: [imageStore.imageForKey(meme.memeKey)!], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // the only method that is required as a delegate of UITableViewDataSource
    // ask for data source for a cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.memes.allMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.bottomText + " " + meme.topText
        cell.imageView?.image = imageStore.imageForKey(meme.memeKey)
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Message: \(meme.topText) ... "
        }
        
        return cell
    }
    
    // Asks the data source to commit the insertion or deletion of a specified row in the receiver
    // the 'indexPath' parameter is the indexPath of the selected row
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        
        // if the table view is asking to commit a delete command
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let item = memes.allMemes[indexPath.row]
            
            // create an alert for deleting
            let title = "Delete \(item.topText)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .ActionSheet)
            
            // nil is passed as the completion handler because nothing should
            // occur
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Cancel,
                                             handler: nil)
            
            // handler | A block to execute when the user selects the action.
            // This block has no return value and takes the selected action object as its only parameter.
            // the selection Action in this case is the Delete action
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .Destructive,
                                             handler: { (action) -> Void in
                                                
                                                // remove the item from the store (our data model for this tableView)
                                                self.memes.removeMeme(item)
                                                
                                                // also remove the row from the table view with an animation
                                                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                                                
                                                // also remove the associated image
                                                self.imageStore.deleteImageForKey(item.memeKey)
            })
            
            // add actions to UIAlertController
            ac.addAction(cancelAction)
            ac.addAction(deleteAction)
            
            // present the AlertController
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    //**************************
    // Private Methods
    //**************************
    
    func startOver(){
        // Obtain the navigationControllerView
        if let navController = self.navigationController {
            navController.popToRootViewControllerAnimated(true)
        }
    }
    
}
    