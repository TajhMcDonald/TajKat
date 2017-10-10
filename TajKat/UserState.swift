//
//  UserState.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//
import Foundation
import UIKit.UIImage

struct UserState {

    // Important: currentUser holds details accessed everywhere in the app about the user
    // This is initialized with empty strings instead of making them optionals to enforce the
    // idea that this object and its properties should NEVER be null.
    
    static var currentUser: UserState = UserState(displayPicture: nil, email: "", name: "", notificationID: "", uid: "", username: "")
    
    var displayPicture: String?     // You will not have a display picture until set
    var email: String
    var name: String
    var notificationID: String
    var uid: String
    var username: String
    
    static func resetCurrentUser() {
        currentUser.displayPicture = nil
        currentUser.email = ""
        currentUser.name = ""
        currentUser.uid = ""
        currentUser.username = ""
        
    }
    
    /*
    init(displayPicture: String, email: String, name: String, notificationID: String, uid: String, username: String) {
        self.displayPicture = displayPicture
        self.email = email
        self.name = name
        self.notificationID = notificationID
        self.uid = uid
        self.username = username
    }*/
}
