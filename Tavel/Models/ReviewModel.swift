//
//  ReviewModel.swift
//  Tavel
//
//  Created by user245540 on 8/5/24.
//

import Foundation
struct ReviewModel {
    let profileImageName: String?
    let name: String
    let rating: Int
    let createdDate: String
    let reviewDetail: String?
    
    init(profileImageName: String?, name: String, rating: Int, createdDate: String, reviewDetail: String?) {
        self.profileImageName = profileImageName
        self.name = name
        self.rating = rating
        self.createdDate = createdDate
        self.reviewDetail = reviewDetail
    }
}
