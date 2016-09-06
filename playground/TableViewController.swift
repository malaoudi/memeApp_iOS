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
    
    // outlets
    @IBOutlet var tableViewDisplay: UITableView!

    // obtain array of Meme's saved in AppDelegate
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //**************************
    // Life Cycle Methods
    //**************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //**************************
    // Table Methods
    //**************************

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // obtain the meme image that was selected
        let meme = self.memes[indexPath.row]
        
        // create ActivityViewController, passing the memeImage to it
        let controller = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // the only method that is required as a delegate of UITableViewDataSource
    // ask for data source for a cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.bottomText + " " + meme.topText
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Message: \(meme.topText) ... "
        }
        
        return cell
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
    