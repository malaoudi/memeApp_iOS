//
//  Meme.swift
//  MemeApp
//
//  Created by Terrence Kuo on 4/5/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

import UIKit

class Meme: NSObject, NSCoding {
    var topText: String
    var bottomText: String
    let memeKey: String
    
    // initialize the Meme
    // this is a designated initializer that is required
    init(topText: String, bottomText: String) {
        self.topText = topText
        self.bottomText = bottomText
        
        // unique id for image
        self.memeKey = NSUUID().UUIDString
    }
    
    // *********************
    // NSCoding delegate func
    // *********************
    
    // Instances of Meme are now NSCoding compliant
    // they can be saved and loaded from the filesystem
    // using archiving
    
    // when an Item is sent the message 'encodeWithCoder', it
    // will encode all of it properties in to the NSCoder
    // obj that pass as an arguement
    // while saving, you will use NSCoder to write out a
    // stream of data
    // the stream will be stored on the filesystem and
    // is organized as key-value pairs
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.topText, forKey: "topText")
        aCoder.encodeObject(self.bottomText, forKey: "bottomText")
        aCoder.encodeObject(self.memeKey, forKey: "memeKey")
    }
    
    // objects being loaded from an unarchieve are sent the message init(coder)
    // this method grabs all the objects that were encoded within
    // the encodeWithCoder and assign them the appropriate property
    required init?(coder aDecoder: NSCoder) {
        self.topText = aDecoder.decodeObjectForKey("topText") as! String
        self.bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
        self.memeKey = aDecoder.decodeObjectForKey("memeKey") as! String
        
        super.init()
    }
}