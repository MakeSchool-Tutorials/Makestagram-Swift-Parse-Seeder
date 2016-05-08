//
//  main.swift
//  MakeItRain
//
//  Created by Jason Katzer on 5/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

import Parse

func setupParse() {
  let configuration = ParseClientConfiguration {
    $0.applicationId = "{{your-parse-app-name}}"
    $0.server = "https://{{your-heroku-app-name}}.herokuapp.com/parse"
  }
  Parse.initializeWithConfiguration(configuration)
}

func randomUsername() -> String {
  let names = ["bob", "cindy", "may", "charles", "javier"]
  // get a name at random
  let name = names[Int(arc4random_uniform(UInt32(names.count)))]
  // get a 4 digit number at random
  let number = arc4random_uniform(8999) + 1000

  return "\(name)\(number)"
}


func makeFakeUser(username: String) {
  let fakeUser = PFUser()
  fakeUser.username = username
  fakeUser.password = "\(username)doesnothaveapassword"
  do{
    try fakeUser.signUp()
  } catch {
    print("could not create user")
    return
  }


  let acl = PFACL()
  acl.publicReadAccess = true
  acl.setWriteAccess(true, forUser: fakeUser)

  let fakePost = PFObject(className: "Post")
  fakePost.setObject(fakeUser, forKey: "user")
  fakePost.ACL = acl

  do {
    try fakePost.save()
  } catch {
    print("could not create user")
  }
}

print ("this app is single threaded, and does not have a UI, so we are going to block the main thread")
print ("setting up parse")
setupParse()
print ("making a fake user")
makeFakeUser(randomUsername())
sleep(10)