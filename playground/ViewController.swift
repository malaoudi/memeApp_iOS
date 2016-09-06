//
//  ViewController.swift
//  playground
//
//  Created by Terrence Kuo on 3/19/16.
//  Copyright © 2016 Terrence Kuo. All rights reserved.
//

import UIKit

// inherit the classes to be a delegate of the UIImagePickerController
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    // character attributes
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0,
    ]
    
    // obtain screen width
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    //**************************
    // Life Cycle Methods
    //**************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign the textfields as delegates
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        // set the default attributes for the textLabels
//        self.topTextField.text = "TOP"
//        self.bottomTextField.text = "BOTTOM"
        
        
        // disable button initially
        shareButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // in case the device doesnt have a camera, disable the cameraButton
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // center the text
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        memeTextAttributes[NSParagraphStyleAttributeName] = style
        
        // set the character attributes to for the TextField
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // subscribe to keyboard notifications, to allow the view to be raised
        self.subscribeToKeyboardNotifications()
        
        // prevent button from being clicked unless an image is present
        if (imagePickerView.image != nil){
            shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe to keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //**************************
    // Image Picker Field Delegate Methods
    //**************************
    
    // method called when the cancel button is selected in the UIImagePickerViewController
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil) // necessary to dismiss the ImagePickerViewController
    }
    
    // method called when an image is selected after bring up the UIImagePickerViewController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // obtains an image from the UIImagePickerViewController via calling a dictionary
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = pickedImage
        }
        
        // necessary to dismiss the UIImagePickerViewController after an image is selected
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //**************************
    // Text Field Delegate Methods
    //**************************
    
    // clear the text when the textField is selected
    func textFieldDidBeginEditing(textField: UITextField){
        textField.text = ""
        self.topTextField.frame.size.width = screenWidth
    }
    
    // dismiss the keyboard when pressing return
    func textFieldShouldReturn( textField: UITextField) -> Bool{
        self.view.endEditing(true) // dismiss keyboard
        return false // prevent default behavior
    }
    
    //**************************
    // NSNotifications
    //**************************

    func subscribeToKeyboardNotifications() {
        // subscribe to a notification that the keyboard will show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // subscribe to a notification that the keyboard will hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // function called when the keyboardShowNotification is invoked
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            // move view accordingly
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    // function called when the keyboardHideNotification is invoked
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            // move view accordingly
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // obtain height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //**************************
    // Private Methods - Actions
    //**************************
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        // make the imagePicker a delegate so that it will follow the methods written above
        // by becoming a delegate, all calls now go through the above methods
        imagePicker.delegate = self // set the delegate before launching the UIImagePickerViewController
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // need a way to specify whether an image is coming from the album or the camera
        // https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIImagePickerController_Class/index.html#//apple_ref/c/tdef/UIImagePickerControllerSourceType
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //**************************
    // Private Methods - MemeObj
    //**************************
    
    @IBAction func save(sender: AnyObject) {
        let memeImage = generateMemedImage()
        
        // Create the Meme, the memedImage is a combination of the Image plus overlayed text
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memeImage)
        
        // Add the Meme to the meme array in App Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        // create ActivityViewController, passing the memeImage to it
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.navigationController?.navigationBar.hidden = true
        self.bottomToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.navigationBar.hidden = false
        self.bottomToolBar.hidden = false

        return memedImage
    }
    
    

}

