//
//  CategoriesModel.swift
//  Tavel
//
//  Created by user245540 on 8/4/24.
//

import Foundation

struct CategoriesModel {
    let imageView: String?
    let title: String?
    let detail: String?
    let location: String?
    
    init(imageView: String?, title: String?, detail: String?, location: String?) {
        self.imageView = imageView
        self.title = title
        self.detail = detail
        self.location = location
    }
}



