//
//  Search.swift
//  Tavel
//
//  Created by user245540 on 8/26/24.
//

import Foundation
// search for places
struct SearchResponse: Decodable {
    let message: String
    let status: Int
    let data: [Pupular]
}
