
import Foundation

struct LoginResponse: Codable {
    let message: String
    let status: Int
    let data: LoginData
}

struct LoginData: Codable {
    let jwt: JWT
}

struct JWT: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    // Custom coding keys to map the JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
