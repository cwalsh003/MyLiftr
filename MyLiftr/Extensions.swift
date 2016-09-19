//
//  Extensions.swift
//  MyLiftr
//
//  Created by Colin Walsh on 9/6/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit

let imageCache = NSCache()


extension UIImageView{
    
    func loadImageUsingCacheWithUrlSrting(urlString: String){
        
        self.image = nil
        
        //checkcache for image first
        
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage
        {
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error)in
            
            if error != nil{
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
                
                
                //                    cell.imageView?.image = UIImage(data: data!)
            })
            
            
        }).resume()
    }
}