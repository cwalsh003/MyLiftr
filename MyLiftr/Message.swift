//
//  message.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/17/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?

    func charPartnerId() -> String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
