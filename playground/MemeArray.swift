//
//  memeArray.swift
//  MemeApp
//
//  Created by Terrence Kuo on 9/6/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

//
//  ItemStore.swift
//  Lits
//
//  Created by Terrence Kuo on 9/3/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

import UIKit

class MemeArray{
    // create an empty array of Items
    var allMemes = [Meme]()
    
    // Item's will be saved to a single file in the Document Directory
    // ItemStore will handle the writing and reading from that file
    // to do this ItemStore needs to construct a URL to this file
    // create URL to file in Documents for saving
    // --------
    // the value is being set by a closure
    // the closure takes no arugments and returns and instance of NSURL
    // when the ItemStore class is instantiated, the closure will run and
    // return the value will be assigned to the itemArchiveURL property
    // this closure is useful for setting a value for a variable or constant
    // that requires multiple lines of code
    let itemArchiveURL: NSURL = {
        // obtain the path to the Document Directory
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        // since the above URLsForDirectory returns an array URL
        // select the first value of the array
        // in iOS there will only be one URL in this array so you can use first
        let documentDirectory = documentsDirectories.first!
        
        // create a name of the archive file and appnd it to the first and
        // only URL in the array
        // this is where the archive Item instances will live
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    init() {
        // load the saved files when ItemStore is created
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Meme] {
            
            // concatinate the two arrays
            allMemes += archivedItems
        }
    }
    
    func addMeme(newMeme: Meme) -> Meme {
        // add the Meme the array
        allMemes.append(newMeme)
        
        return newMeme
    }
    
    func removeMeme(meme: Meme) {
        // check if item exists in the array of Items
        if let index = allMemes.indexOf(meme){
            allMemes.removeAtIndex(index)
        }
        
        saveChanges()
    }
    
    func moveMemeAtIndex(fromIndex: Int, toIndex: Int){
        if (fromIndex == toIndex){
            return
        }
        else{
            // get reference to object being moved
            let movedItem = allMemes[fromIndex]
            
            // remove item from array
            allMemes.removeAtIndex(fromIndex)
            
            // add the item back in
            allMemes.insert(movedItem, atIndex: toIndex)
        }
    }
    
    // **********
    // Archieve Functions use to kick off the saving and loading processes
    // **********
    
    func saveChanges() -> Bool {
        print("Saving items to \(itemArchiveURL.path!)")
        
        // call NSKeyedArchiver to save information persistently
        return NSKeyedArchiver.archiveRootObject(allMemes, toFile: itemArchiveURL.path!)
    }
    
    
    
    
}