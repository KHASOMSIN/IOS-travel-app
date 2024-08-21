//
//  SettingModel.swift
//  Tavel
//
//  Created by user245540 on 8/4/24.
//

import UIKit

struct userProfile {
    let profileImage , name : String?
    
    init(profileImage: String?, name: String?) {
        self.profileImage = profileImage
        self.name = name
    }
}

struct settingOption {
    let iconImage, name: String?
    
    init(iconImage: String?, name: String?) {
        self.iconImage = iconImage
        self.name = name
    }
}
