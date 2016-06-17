//
//  ParseSeeder.swift
//  MakestagramParseSeeder
//
//  Created by Daniel Haaser on 6/17/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Cocoa
import Parse

class ParseSeeder {

    static func seedParse() {
        
        for x in 1...Configuration.numberOfPosts {
            print ("Making fake user: \(x)/\(Configuration.numberOfPosts)")
            
            let randomUsername = generateRandomUsername()
            
            guard let randomImageData = grabRandomImageData() else {
                print("Couldn't find images")
                return
            }
            
            guard let newUser = generateUserWithUsername(randomUsername) else {
                print ("New user creation failed")
                return
            }
                
            createFakePostWithUser(newUser, andImageData: randomImageData)
        }
    }
    
    static func generateRandomUsername() -> String {
        
        let first_names = ["Bob", "Cindy", "May", "Charles", "Javier", "Arnold", "Daniel"]
        let last_names = ["Smith", "Carmack", "James", "Torvalds", "Schwarzenegger"]
        
        // generate first and last names
        let first_name = first_names[Int(arc4random_uniform(UInt32(first_names.count)))]
        let last_name = last_names[Int(arc4random_uniform(UInt32(last_names.count)))]
        
        // generate a random four digit number
        let number = arc4random_uniform(8999) + 1000
        
        return "\(first_name)\(last_name)\(number)"
    }
    
    static func generateUserWithUsername(username: String) -> PFUser? {
        let user = PFUser()
        user.username = username
        user.password = "\(username)-password"
        
        do {
            try user.signUp()  // synchronous sign up
        } catch {
            return nil
        }
        
        return user
    }
    
    static func createFakePostWithUser(user: PFUser, andImageData imageData: NSData) {
        
        guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {
            print("Couldn't create Parse File for image")
            return
        }
        
        let post = PFObject(className: "Post")
        
        post.setObject(user, forKey: "user")
        post.setObject(imageFile, forKey: "imageFile")
        post.ACL = generateACLForUser(user)
        
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("Successfully added post for \(user.username ?? "")")
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    static func grabRandomImageData() -> NSData? {
        let randomNumber = arc4random_uniform(10) + 1
        let imageName = "cat\(randomNumber)"
        
        if let imageURL = NSBundle.mainBundle().URLForResource(imageName, withExtension: ".jpg") {
            return NSData(contentsOfURL: imageURL)
        } else {
            return nil
        }
    }
    
    static func generateACLForUser(user: PFUser) -> PFACL {
        let acl = PFACL()
        acl.publicReadAccess = true
        acl.setWriteAccess(true, forUser: user)
        return acl
    }
    
}