//
//  ChatMessageCell.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/23/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT"
        tv.font = UIFont.systemFontOfSize(16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not be inplemented")
    }
}
