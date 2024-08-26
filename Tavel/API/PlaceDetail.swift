struct Place: Decodable {
    let placeId: Int
    let placeName: String
    let locationId: Int
    let provinceId: Int
    let description: String
    let detailTitle: String
    let detailText: String
    let categoryId: Int?
    let imageUrl: String
    let provinceName: String? // Add this property to handle the province name

    enum CodingKeys: String, CodingKey {
        case placeId
        case placeName
        case locationId
        case provinceId
        case description
        case detailTitle
        case detailText
        case categoryId
        case imageUrl = "image_url"
        case provinceName // Add this case to map the province name
    }
}
