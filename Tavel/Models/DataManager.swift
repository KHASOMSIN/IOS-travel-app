//
//  DataManager.swift
//  Tavel
//
//  Created by user245540 on 7/20/24.
//

import Foundation
class DataManager {
    static let shared = DataManager()

    var email: String?

    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
