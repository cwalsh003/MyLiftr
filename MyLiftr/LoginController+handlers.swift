//
//  LoginController+handlers.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/3/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    
    func handleRegister(){
        
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text
            else{
                return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil{
                print(error)
                return
            }
            guard let uid = user?.uid else{return}
            
            
            
            
            //successfully authenticated
            
            let imageName = NSUUID().UUIDString
            
            let storageRef = FIRStorage.storage().reference().child("profileImage").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            
//            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                
                storageRef.putData(uploadData, metadata: nil, completion:
                    { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                        
                    }
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                            
                            
                        
                       let values = ["name": name, "email": email, "profileImageUrl":profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values)
                    
                        }
                        
                    })
                }
            })
        }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
//        let values = ["name": name, "email": email, "profileImageUrl": metadata.downloadUrl()]
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print (err)
            }
            //save successfully into database
            print("saved successfully into database")
            
//            self.messagesController?.fetchUserAndSetupNavbar()
            
//            self.messagesController?.navigationItem.title = values["name"] as? String
            
            let user = User()
            user.setValuesForKeysWithDictionary(values)
            self.messagesController?.setupNavBarWithUser(user)
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    func handleSelectProfileImageVIew() {
        let picker = UIImagePickerController()
        presentViewController(picker, animated: true, completion: nil)
        
        picker.delegate = self
        picker.allowsEditing = true
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"]{
            selectedImageFromPicker = editedImage as! UIImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImageFromPicker = originalImage as! UIImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
