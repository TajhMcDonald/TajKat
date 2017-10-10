//
//  TextModel.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class TextModel: TextMessageModel<MessageModel> {
    
    
    static let chatItemType = "text"
    
    override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
    
    
    var status: MessageStatus {
        
        get {
            return self._messageModel.status
        } set {
            self._messageModel.status = newValue
        }
    }
}
