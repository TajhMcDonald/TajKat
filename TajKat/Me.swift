//
//  Me.swift
//  TajKat
//
//  Created by Admin on 7/18/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation
import FirebaseAuth

class Me {
    static var uid: String {
        return Auth.auth().currentUser!.uid
    }
}
