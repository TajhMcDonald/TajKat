//
//  Avatar.swift
//  TajKat
//
//  Created by Admin on 7/25/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import Foundation
import ChattoAdditions


class Avatar : BaseMessageCollectionViewCellDefaultStyle {
    override func avatarSize(viewModel: MessageViewModelProtocol) -> CGSize {
        return viewModel.isIncoming ? CGSize(width: 30, height: 30) : CGSize.zero

//        return CGSize(width: 30, height: 30)
    }
//    return viewModel.isIncoming ? CGSize(width: 30, height: 30) : CGSize.zero
}
