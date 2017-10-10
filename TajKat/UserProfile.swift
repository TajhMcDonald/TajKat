//
//  UserProfile.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation

public class UserProfile {
    
    var displayName: String
    var uid: String
    var username: String
    var email: String
    
    // Note: displayPicture should be used as little as possible and phased out
    // All display picture URLs can be composed with the user's UID, thus elimintating need to store this
    //var displayPicture: String

    init(displayName: String, uid: String, username: String, email: String) {
        self.displayName = displayName
        self.uid = uid
        self.username = username
        self.email = email
    }
}
