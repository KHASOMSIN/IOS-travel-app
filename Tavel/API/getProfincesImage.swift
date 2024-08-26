import Foundation
import Alamofire

// Define your ImageData struct
struct ImageData: Codable {
    let imageId: Int
    let placeId: Int
    let imageUrl: String
}

// Fetch images for a specific province ID
func fetchProvinceImages(for id: Int, completion: @escaping (Result<[ImageData], APIError>) -> Void) {
    let url = "https://travel-flame-ten.vercel.app/travel/placeImages/\(id)"
    
    AF.request(url, method: .get).validate().responseDecodable(of: [ImageData].self) { response in
        switch response.result {
        case .success(let imageDataArray):
            completion(.success(imageDataArray))
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
