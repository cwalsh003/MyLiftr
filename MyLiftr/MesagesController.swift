//
//  ViewController.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/2/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase


class MessagesController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "compose-nav-button")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
      //  observeMessage()
        
    
        
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        ref.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let messageId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        let message = Message()
                        message.setValuesForKeysWithDictionary(dictionary)
                        
                        
                        if let chatPartnerId = message.chatPartnerId() {
                            self.messagesDictionary[chatPartnerId] = message
                            
                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sortInPlace({ (message1, message2) -> Bool in
                                
                                return message1.timestamp?.intValue > message2.timestamp?.intValue
                            })
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    
    func observeMessage(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                 let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                self.messages.append(message)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sortInPlace({ (message1, message2) -> Bool in
                        
                        return message1.timestamp?.intValue > message2.timestamp?.intValue
                    })
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                })
            }
            
           
            
        }, withCancelBlock: nil)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
        
        //cell.textLabel?.text = message.toId
  
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let message = messages[indexPath.row]
    
    guard let chatPartnerId = message.chatPartnerId() else{
        return
    }
    
    let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
    
    ref.observeEventType(.Value, withBlock: {(snapshot) in
        
        guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
        
        let user = User()
        
        user.id = chatPartnerId
        
        user.setValuesForKeysWithDictionary(dictionary)
        self.showChatController(user)
        
        }, withCancelBlock: nil)
    
    }
    
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        
        presentViewController(navController, animated: true, completion: nil)
        
        
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavbar()
                    }
    }
    
    func fetchUserAndSetupNavbar(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                print(dict["name"])
//                self.navigationItem.title = dict["name"] as? String
                
                let user = User()
                user.setValuesForKeysWithDictionary(dict)
                self.setupNavBarWithUser(user)
            }
            }, withCancelBlock: nil)

    }
    
    func setupNavBarWithUser(user: User){
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlSrting(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        
        profileImageView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(40).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(40).active = true
        
        let nameLabel = UILabel()
         containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(profileImageView.centerYAnchor).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        nameLabel.heightAnchor.constraintEqualToAnchor(profileImageView.heightAnchor).active = true
        
        containerView.centerXAnchor.constraintEqualToAnchor(titleView.centerXAnchor).active = true
        containerView.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        
       
        
        self.navigationItem.titleView = titleView
        
   //     titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCharController)))
    }
    
    func showChatController(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    func handleLogout() {
        
            do{
                try FIRAuth.auth()?.signOut()
            }catch let logoutError{
                print(logoutError)
            }
        


        let loginController = LoginController()
        loginController.messagesController = self
        presentViewController(loginController, animated: true, completion: nil)
    }

}

