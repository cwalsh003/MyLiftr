//
//  LoginController.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/2/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase

class LoginController: UIViewController {
    
    var messagesController: MessagesController?
    
    let  inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 88, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {(user, error)
        in
            if error != nil{
                print (error)
                return
            }
            
            self.messagesController?.fetchUserAndSetupNavbar()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageVIew)))
        imageView.userInteractionEnabled = true
        return imageView
    }()
   
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleToggle), forControlEvents: .ValueChanged)
        return sc
    }()
    
    func handleToggle(){
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        //change height of inputCOntainerView
        inputContainerHeightViewAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
       nameTextFieldHeightViewAnchor?.active = false
        nameTextFieldHeightViewAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0.00 : 1/3)
        if(loginRegisterSegmentedControl.selectedSegmentIndex == 0){
            nameTextField.placeholder = ""
        }else{
            nameTextField.placeholder = "Name"
        }
        print(loginRegisterSegmentedControl.selectedSegmentIndex)
        nameTextFieldHeightViewAnchor?.active = true
        
        
        
        emailTextHeightViewAnchor?.active = false
        emailTextHeightViewAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextHeightViewAnchor?.active = true
        
        passwordTextHeightViewAnchor?.active = false
        passwordTextHeightViewAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextHeightViewAnchor?.active = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g:91 ,b:151)
       
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(profileImageView)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupProfileImageView()
        
        
        
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(loginRegisterSegmentedControl.topAnchor, constant: -29).active = true
        profileImageView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, multiplier: 1/2).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        //x, y, width, height
        
        loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(nameTextField.topAnchor, constant: -19).active = true
        loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor, multiplier: 1).active = true
        loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(36).active = true
    }
    
    func setupLoginRegisterButton() {
        //x, y, width, height
        
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    var inputContainerHeightViewAnchor: NSLayoutConstraint?
    var nameTextFieldHeightViewAnchor: NSLayoutConstraint?
    var nameTextFieldTopAnchor: NSLayoutConstraint?
    var emailTextHeightViewAnchor: NSLayoutConstraint?
     var passwordTextHeightViewAnchor: NSLayoutConstraint?
    
    
    func setupInputsContainerView() {
        //x, y, width, height constraints
        
        inputContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        
            inputContainerHeightViewAnchor = inputContainerView.heightAnchor.constraintEqualToConstant(150)

        inputContainerHeightViewAnchor?.active = true
        
        
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)
        
        
        //x, y, width, height constraints
        
        nameTextField.leftAnchor.constraintEqualToAnchor(inputContainerView.leftAnchor,constant: 12).active = true
        
        nameTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        
        nameTextFieldTopAnchor = nameTextField.topAnchor.constraintEqualToAnchor(inputContainerView.topAnchor)
        nameTextFieldTopAnchor?.active = true
        
        nameTextFieldHeightViewAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3)
            
            nameTextFieldHeightViewAnchor?.active = true
        
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        emailTextField.leftAnchor.constraintEqualToAnchor(inputContainerView.leftAnchor,constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameSeparatorView.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        
        emailTextHeightViewAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3)
            
            emailTextHeightViewAnchor?.active = true
        
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputContainerView.leftAnchor,constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailSeparatorView.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputContainerView.widthAnchor).active = true
        
         passwordTextHeightViewAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputContainerView.heightAnchor, multiplier: 1/3)
            
            passwordTextHeightViewAnchor?.active = true

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return.LightContent
    }


    
    
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
