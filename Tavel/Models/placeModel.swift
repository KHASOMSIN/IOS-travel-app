//
//  placeModel.swift
//  Tavel
//
//  Created by user245540 on 8/9/24.
//

import Foundation
struct placeModel {
    let title: String
    let locationIconName: String
    let locationName: String
    let detail: String
    let galleryName: String
    
    init(title: String, locationIconName: String, locationName: String, detail: String, galleryName: String) {
        self.title = title
        self.locationIconName = locationIconName
        self.locationName = locationName
        self.detail = detail
        self.galleryName = galleryName
    }
}

