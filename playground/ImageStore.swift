//
//  ImageStore.swift
//  MemeApp
//
//  Created by Terrence Kuo on 9/6/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

// keeping hundres of images in main memory (RAM) is bad
// 1) you will get a low memory warning
// 2) if your memory footprint continues to grow, the OS will shut down
// solution: stores images in DISK and only fetch them into RAM when needed

// when the app recieved a low-memory warning, the ImageStore's cache will be flushed 
// to free the memory that hte fetched images were occupying

import UIKit

class ImageStore: NSObject {
    // work like a dictionary
    // allow you to add, remove and update values with a key
    // the cache will AUTOMATICALLY remove objects if the system 
    // gets low on memory
    let cache = NSCache()
    
    // adding an image
    func setImage(memeImage: UIImage, forKey key: String){
        cache.setObject(memeImage, forKey: key)
        
        // Turn Image into JPEG data
        // copy a JPEG representation of the image into a buffer in memory
        // NSData: create, maintain, and destroy buffer
        // - holds some number of bytes of binary data 
        // - use NSData to story the image data
        
        // create full URL for Image
        let imageURL = imageURLForKey(key)
        
        // Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(memeImage, 0.5){
            // write to full URL and save the image
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    // retrieve image
    func imageForKey(key: String) -> UIImage? {
        // check cache first to see if image is here
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        
        // obtain image from Disk 
        let imageUrl = imageURLForKey(key)
        
        // obtain the image from a given URL
        guard let imageFromDisk = UIImage(contentsOfFile: imageUrl.path!) else{
            return nil
        }
        
        // place the image in cache
        cache.setObject(imageFromDisk, forKey: key)
        
        return imageFromDisk
    }
    
    // delete image
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        
        // delete item from Persistent storage
        let imageURL = imageURLForKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch let deleteError {
            print ("eror removing image from disk: \(deleteError)")
        }
    }
    
    // add image to persistent storage
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectory.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
}