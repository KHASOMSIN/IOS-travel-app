//
//  getPlaces.swift
//  Tavel
//
//  Created by user245548 on 8/22/24.
//

import Alamofire

struct APIPlaces {
    static let shared = APIPlaces()
    func fetchProvinces(completion: @escaping ([ProvincesModel]?) -> Void) {
        let url = "\(urlLocal)travel/places"
        
        AF.request(url).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                completion(apiResponse.provinces)
            case .failure(let error):
                print("Error fetching provinces: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
