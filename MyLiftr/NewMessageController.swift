//
//  NewMessageController.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/3/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase



class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()

    }
    
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapshot.key
                
                user.setValuesForKeysWithDictionary(dict)
                
                self.users.append(user)
                
                dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                })
                
                //print(user.name, user.email)
            }
            
            print(snapshot)
            
        }, withCancelBlock: nil)
    }
    
    func handleCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        

        
        
        if let profileImageUrl = user.profileImageUrl{
            
          cell.profileImageView.loadImageUsingCacheWithUrlSrting(profileImageUrl)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true) {
            
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(user)
        }
        
        
    }
    
    }








