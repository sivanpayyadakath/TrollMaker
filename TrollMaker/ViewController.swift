//
//  ViewController.swift
//  TrollMaker
//
//  Created by Sivan.Payyadakath on 2019/04/25.
//  Copyright © 2019 Sivan.Payyadakath. All rights reserved.
//

import UIKit

struct Troll {
    var textTop: String = "TOP"
    var textBottom: String = "BOTTOM"
    var imageOriginal: UIImage?
    var editedImage: UIImage?
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var imagePicker: UIBarButtonItem!
    @IBOutlet weak var cameraImagePicker: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let trollTextAttribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 50
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topField.delegate = self
        bottomField.delegate = self
        topField.isHidden = true
        bottomField.isHidden = true
        // Do any additional setup after loading the view.
        
        //topField.defaultTextAttributes: trollTextAttribute
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func photoPicked(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func photoShare(_ sender: Any) {
        let trollImage = generateTrollImage()
        let controller = UIActivityViewController(activityItems: [trollImage], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = self.view //so that ipdas wont crash
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cameraPhotoPicked(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage.image = image
        }
        dismiss(animated: true, completion: nil)
        topField.isHidden = false
        bottomField.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("nigga cancelled selection")
        dismiss(animated: true, completion: nil)
    }
    
    func save(trollImage: UIImage){
        _ = Troll(textTop: topField.text!, textBottom: bottomField.text!, imageOriginal: selectedImage.image!, editedImage: trollImage)
    
    }
    
    func generateTrollImage() -> UIImage {
            //Render view to image (screenshots)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let trollImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return trollImage
        
    }
    
    
    
}

