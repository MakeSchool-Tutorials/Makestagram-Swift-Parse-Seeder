//
//  main.swift
//  MakeItRain
//
//  Created by Jason Katzer on 5/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

import Parse

func badRequest(url: String) -> NSData {
  let request = NSURLRequest(URL: NSURL(string: url)!)
  var response: NSURLResponse?
  return try! NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
}

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
  print("Making fake user: \(username)")
  let fakeUser = PFUser()
  fakeUser.username = username
  fakeUser.password = "\(username)doesnothaveapassword"
  do{
    try fakeUser.signUp()
  } catch {
    print("could not create user \(username)")
    return
  }


  let acl = PFACL()
  acl.publicReadAccess = true
  acl.setWriteAccess(true, forUser: fakeUser)


  let imageFile = PFFile(data: badRequest("http://thecatapi.com/api/images/get"))

  do {
    try imageFile!.save()
  } catch {
    print("could not upload image")
    return
  }

  print("Making fake post for user: \(username)")
  let fakePost = PFObject(className: "Post")
  fakePost.setObject(fakeUser, forKey: "user")
  fakePost.setObject(imageFile!, forKey: "imageFile")
  fakePost.ACL = acl

  do {
    try fakePost.save()
  } catch {
    print("could not create post for user \(username)")
  }
}

print ("this app is single threaded, and does not have a UI, so we are going to block the main thread")
print ("setting up parse")
let number_of_users = 10
setupParse()
for x in 1...number_of_users {
  print ("making fake user: \(x)/\(number_of_users)")
  makeFakeUser(randomUsername())
}
print ("done")