//
//  ProvincesModel.swift
//  Tavel
//
//  Created by user245540 on 7/30/24.
//

import Foundation
import UIKit

struct APIResponse: Decodable {
    let message: String
    let provinces: [ProvincesModel]
}

struct ProvincesModel: Decodable {
    let provinceId: Int
    let provinceImage: String
    let provinceName: String
}
