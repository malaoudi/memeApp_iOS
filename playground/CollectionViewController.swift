//
//  CollectionViewController.swift
//  MemeApp
//
//  Created by Terrence Kuo on 4/6/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

import Foundation
import UIKit

// inherit the classes to be a delegate of the UIImagePickerController
class CollectionViewController: UICollectionViewController {
    
    //**************************
    // Private Variables
    //**************************
    
    // outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // variables
    var space: CGFloat = 0.0;
    var width: CGFloat = 0.0;
    var height: CGFloat = 0.0;
    

    // obtain array of Meme from persistent storage
    var memes: MemeArray = MemeArray()
    var imageStore: ImageStore = ImageStore()
    
    //**************************
    // Lifecyle Methods
    //**************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.space = (3.0)
        
        // set size of the cell in respect to the screen size
        self.width = self.view.frame.size.width
        self.height = self.view.frame.size.height
        
        let Dimension = ( self.width - (2 * self.space))/3.0
        
        // governs the space between rows or columns
        self.flowLayout.minimumInteritemSpacing = self.space
        // governs the space between items within a row or column
        self.flowLayout.minimumLineSpacing = self.space
        // property governs cell size
        self.flowLayout.itemSize = CGSizeMake(Dimension, Dimension)
        
        // change background color of UICollectionViewController
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let space: CGFloat = (3.0)
        
        let smallSide = min(self.view.frame.size.width, self.view.frame.size.height)
        let Dimension = (smallSide - (2 * space))/3.0
        
        
        self.flowLayout.itemSize = CGSizeMake(Dimension, Dimension)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // if landscape
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            print("landscape")

            // set size of the cell in respect to the screen size
            let Dimension = (self.height-(2 * self.space))/3.0
            
            // governs the space between rows or columns
            self.flowLayout.minimumInteritemSpacing = space
            // governs the space between items within a row or column
            self.flowLayout.minimumLineSpacing = space
            // property governs cell size
            self.flowLayout.itemSize = CGSizeMake(Dimension, Dimension)
        }
        else{ // portrait
            print("portrat")

            // set size of the cell in respect to the screen size
            let Dimension = (self.width - (2 * self.space))/3.0
            
            // governs the space between rows or columns
            self.flowLayout.minimumInteritemSpacing = self.space
            // governs the space between items within a row or column
            self.flowLayout.minimumLineSpacing = self.space
            // property governs cell size
            self.flowLayout.itemSize = CGSizeMake(Dimension, Dimension)
        }
    }
    
    //**************************
    // Collection Methods
    //**************************
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes.allMemes[indexPath.item]
        //cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: imageStore.imageForKey(meme.memeKey))
        cell.backgroundView = imageView
        //cell.imageViewCell = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // obtain the meme image that was selected
        let meme = self.memes.allMemes[indexPath.row]
        
        // create ActivityViewController, passing the memeImage to it
        let controller = UIActivityViewController(activityItems: [imageStore.imageForKey(meme.memeKey)!], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
    