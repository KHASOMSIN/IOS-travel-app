//
//  getProvinces.swift
//  Tavel
//
//  Created by user245540 on 8/22/24.
//

import Alamofire

struct APIClient {
    static let shared = APIClient()
    
    func fetchProvinces(completion: @escaping ([ProvincesModel]?) -> Void) {
        let url = "\(urlLocal)travel/provinces"
        
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
