//
//  AppDelegate.swift
//  MakestagramParseSeeder
//
//  Created by Daniel Haaser on 6/17/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Cocoa
import Parse

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = Configuration.applicationID
            $0.server = Configuration.serverURL
        }
        Parse.initializeWithConfiguration(configuration)
        
        ParseSeeder.seedParse()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

