//
//  OTP.swift
//  Tavel
//
//  Created by user245540 on 8/25/24.
//

import Foundation

struct OTPResponse: Codable {
    let status: Int
    let message: String
    let data: OTPData?
}

struct OTPData: Codable {
    let message: String
    let expiresAt: String?
    let otpCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case message
        case expiresAt = "expires_at"
        case otpCode = "otp_code"
    }
}
