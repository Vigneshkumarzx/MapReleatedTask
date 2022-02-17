//
//  File.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation
import GoogleMaps
import GooglePlaces


struct NetworkService {
    static let shared = NetworkService()
    private init() {}
  
    func makeRequestForRouteDirection(with params: [String: Any], completion: @escaping (Result<GoogleMapRouteResponse, Error>) -> Void) {
        request(route: .destinationDirections, parameter: params, type: GoogleMapRouteResponse.self,completion: completion)
    }
   
    func makeRequestForNearByResturents(with params: [String: Any], completion: @escaping (Result<NearByResturentResponse, Error>) -> Void) {
        request(route: .nearByResturents, parameter: params, type: NearByResturentResponse.self,completion: completion)
    }
    private func request<T: Codable>(route: Route,
                                     method: HTTPMethod = .GET,
                                     parameter: [String: Any]? = nil,
                                     type: T.Type,
                                     completion: @escaping (Result<T, Error>) -> Void) {
        let request = createRequest(route: route, method: method, parameter: parameter)
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            
            if let data = data {
                let responseString = String(data: data, encoding: .utf8) ?? "Unable to convert as string."
                print("Response is:\(responseString)")
                
                let decoder = JSONDecoder()
                
                guard let result = try? decoder.decode(type, from: data) else{
                    print("Error Happening!")
                    return
                }
                completion(.success(result))
            } else if let error = error {
                print("Error is: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
 
    private func createRequest(route: Route,
                               method: HTTPMethod = .GET,
                               parameter: [String: Any]? = nil) -> URLRequest {
        let urlString = Route.baseURL + route.description
        let url = urlString.asURL
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameter {
            switch method {
            case .GET:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map {URLQueryItem(name: $0, value: "\($1)")}
                
                urlRequest.url = urlComponent?.url
            case .POST, .DELETE, .PATCH:
                let bodyData = try? JSONSerialization.data(withJSONObject: params,
                                                           options: [])
                urlRequest.httpBody = bodyData
                
            }
        }
        return urlRequest
    }
}
extension String {
    var asURL: URL {
        return URL(string: self)!
    }
}
