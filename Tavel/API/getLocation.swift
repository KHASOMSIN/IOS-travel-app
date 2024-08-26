import Foundation

struct Location: Decodable {
    let locationId: Int
    let provinceId: Int
    let locationName: String
    let latitude: String
    let longitude: String
}
