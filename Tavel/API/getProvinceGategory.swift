//
//  getProvinceGategory.swift
//  Tavel
//
//  Created by user245540 on 8/23/24.
//
import Alamofire
import Foundation

struct Category: Codable {
    let categoryId: Int
    let imageIcon: String
    let categoryTitle: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case imageIcon
        case categoryTitle = "category_title"
    }
}

struct CategoriesResponse: Codable {
    let message: String
    let categories: [Category]
}
