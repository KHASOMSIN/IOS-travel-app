//
//  Popular.swift
//  Tavel
//
//  Created by user245540 on 8/24/24.
//

import Alamofire
import Foundation

struct Pupular: Codable {
    let placeId: Int
    let placeName: String
    let locationId: Int
    let provinceId: Int
    let description: String
    let detailTitle: String
    let detailText: String
    let categoryId: Int?
    let imageUrl: String
    var isSaved: Bool?
    let provinceName: String?
    enum CodingKeys: String, CodingKey {
        case placeId, placeName, locationId, provinceId, description, detailTitle, detailText, categoryId, provinceName
        case imageUrl = "image_url"
    }
}

struct APIPupular {
    static let shared = APIPupular()
    private init() {}

    let urlString = "\(urlTravel)travel/places"

    func fetchPlaces(completion: @escaping (Result<[Pupular], Error>) -> Void) {
        AF.request(urlString).responseDecodable(of: [Pupular].self) { response in
            switch response.result {
            case .success(let places):
                completion(.success(places))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

