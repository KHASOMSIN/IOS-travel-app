//
//  getDetail.swift
//  Tavel
//
//  Created by user245540 on 8/23/24.
//

import Foundation

struct Province: Decodable {
    let provinceID: Int
    let description: String
    let galleryPhotos: String?
    let detailTitle: String
    let detailText: String?
    let locationId: Int
    let reviewId: Int?
    
    private enum CodingKeys: String, CodingKey {
        case provinceID = "provinceID"
        case description
        case galleryPhotos = "gallery_photos"
        case detailTitle = "detail_title"
        case detailText = "detail_text"
        case locationId = "locationId"
        case reviewId = "reviewId"
    }
}

import Alamofire

func fetchProvinceData(by id: Int, completion: @escaping (Result<Province, Error>) -> Void) {
    let url = "\(urlTravel)/travel/provinceDetails/\(id)" // Replace with your API URL

    AF.request(url).validate().responseData { response in
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let province = try decoder.decode(Province.self, from: data)
                completion(.success(province))
            } catch {
                // Log detailed error information for debugging
                print("Error decoding data: \(error)")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Response JSON: \(json)")
                }
                completion(.failure(error))
            }
        case .failure(let error):
            // Log the error and response data
            print("Request error: \(error)")
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Error response JSON: \(json)")
                }
            }
            completion(.failure(error))
        }
    }
}
