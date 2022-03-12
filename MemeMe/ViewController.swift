//
//  ViewController.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/7/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UITextFieldDelegate {
    
    var cropViewNeedsRedraw = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cropButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbarView: UIToolbar!
    @IBOutlet weak var toolbarView: UIToolbar!
    
    @IBOutlet weak var cropView: CropView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        cropButton.isEnabled = false
        
        setUpTextField(topTextField, text: "TOP")
        setUpTextField(bottomTextField, text: "BOTTOM")
        
        subscribeToKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cropView.drawCropper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if cropViewNeedsRedraw {
            cropView.redraw()
            cropViewNeedsRedraw = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cropViewNeedsRedraw = true
    }
            
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        shareButton.isEnabled = true
        cropButton.isEnabled = true
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickImage(_ sender: Any) {
        presentImagePicker(.photoLibrary)
    }
    
    @IBAction func takeImage(_ sender: Any) {
        presentImagePicker(.camera)
    }
    
    func presentImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        present(pickerController, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func setUpTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -4.0
        ]
        
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { _, completed, _, _ in
            if completed {
                self.save(memedImage: memedImage)
                self.returnToPreviousView()
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: memedImage
        )
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        let cropImage = !cropView.isHidden
        
        toggleToolbars(hide: true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleToolbars(hide: false)

        if cropImage {
            var frame = cropView.outerRect.frame
            frame.origin.y += topToolbarView.frame.origin.y + topToolbarView.frame.height
            let croppedCGImage = memedImage.cgImage?.cropping(to: frame)
            
            return UIImage(cgImage: croppedCGImage!)
        }
        return memedImage
    }
    
    func toggleToolbars(hide isHidden: Bool) {
        toolbarView.isHidden = isHidden
        topToolbarView.isHidden = isHidden
        cropView.isHidden = isHidden
    }
    
    @IBAction func toggleCropView(_ sender: Any) {
        let isHidden = !cropView.isHidden
        
        cropView.isHidden = isHidden
        topTextField.isEnabled = isHidden
        bottomTextField.isEnabled = isHidden
    }
    
    @IBAction func returnToPreviousViewAction(_ sender: Any) {
        returnToPreviousView()
    }
    
    func returnToPreviousView() {
        self.navigationController?.popViewController(animated: true)
    }
}
