//
//  PhotoBuilder.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class photoViewModel: PhotoMessageViewModel<PhotoModel>{
    override init(photoMessage: PhotoModel, messageViewModel: MessageViewModelProtocol) {
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
    }
}
class PhotoBuilder: ViewModelBuilderProtocol{
    let defaultBuilder = MessageViewModelDefaultBuilder()
    func canCreateViewModel(fromModel decoratedPhotoMessage: Any) -> Bool {
        return decoratedPhotoMessage is PhotoModel
    }
    
    
    func createViewModel(_ decoratedPhotoMessage: PhotoModel) -> photoViewModel {
        let photoMessageViewModel = photoViewModel(photoMessage: decoratedPhotoMessage, messageViewModel: defaultBuilder.createMessageViewModel(decoratedPhotoMessage))
        photoMessageViewModel.avatarImage.value = #imageLiteral(resourceName: "man")
        return photoMessageViewModel
    }
}
