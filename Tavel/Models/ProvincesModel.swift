//
//  ProvincesModel.swift
//  Tavel
//
//  Created by user245540 on 7/30/24.
//

import Foundation
import UIKit


struct ProvincesModel {
    let title: String?
    let killometter: Int?
    let nationalState: String?
    let imageName: String?
    
    init(title: String?, killometter: Int?, nationalState: String?, imageName: String?) {
        self.title = title
        self.killometter = killometter
        self.nationalState = nationalState
        self.imageName = imageName
    }
    
    var formattedKilometer: String {
            let titleText = title ?? "Unknown"
            let kilometerText = killometter.map { "\($0) Km" } ?? "Unknown distance"
            return "Phnom Penh - \(titleText)\(kilometerText)"
        }
        
        var formattedNationalState: String {
            let stateText = nationalState ?? "Unknown state"
            return "National State:\(stateText)"
        }
}

