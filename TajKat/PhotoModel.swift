//
//  PhotoModel.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoModel: PhotoMessageModel<MessageModel> {
    static let chatItemType = "photo"

    override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
    }
    
    
    var status: MessageStatus {
        
        get {
            return self._messageModel.status
        } set {
            self._messageModel.status = newValue
        }
    }

    
    
    
    
    
    
}
