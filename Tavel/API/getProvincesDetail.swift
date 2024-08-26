//
//  getProvincesDetail.swift
//  Tavel
//
//  Created by user245548 on 8/23/24.
//

struct ProvinceImage: Codable {
    let provinceId: Int
    let imageUrl: String?
}

import Alamofire
import Foundation
enum APIError: Error {
    case networkError
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    case customError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Please check your internet connection."
        case .serverError(let statusCode):
            return "Server error with status code \(statusCode). Please try again later."
        case .decodingError:
            return "Failed to decode the response. Please try again."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        case .customError(let message):
            return message
        }
    }
}

class APIManager {
    static let shared = APIManager()

    private init() {}

    func fetchProvinceImages(for id: Int, completion: @escaping (Result<[ProvinceImage], APIError>) -> Void) {
        let url = "\(urlTravel)travel/provincesImage/\(id)"
        
        AF.request(url, method: .get).validate().responseDecodable(of: [ProvinceImage].self) { response in
            switch response.result {
            case .success(let provinceImages):
                completion(.success(provinceImages))
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .notConnectedToInternet:
                        completion(.failure(.networkError))
                    default:
                        if let responseCode = response.response?.statusCode {
                            completion(.failure(.serverError(statusCode: responseCode)))
                        } else {
                            completion(.failure(.unknownError))
                        }
                    }
                } else if error.isResponseSerializationError {
                    completion(.failure(.decodingError))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
}

