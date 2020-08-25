//
//  NetworkManager.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class NetworkManager {
    
    enum NetworkError: Error {
        case dataButNoInfo
    }
    
    func getMoviesInfo(urlPathString: String, completionHandler: @escaping (Result<(String?, Int?), Error>) -> Void) {
        //prototype function for verifying connection to server & retrieval of data, w/API key
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
//        let baseURLString = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc"
                
        guard let apiKey = ProcessInfo.processInfo.environment["TMAK"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "api.themoviedb.org"
        uc.path = urlPathString
        uc.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
                
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
//                    print("network call failed: \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("did not receive response")
                    completionHandler(.success((nil, nil)))
                    return
                }
                
//                print("received response with status code: \(httpResponse.statusCode)")
                
                guard let data = data else {
                    print("did not receive data")
                    completionHandler(.success((nil, httpResponse.statusCode)))
                    return
                }
                
                if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
//                    print("received data: \(responseDataAsString)")
                    completionHandler(.success((responseDataAsString, httpResponse.statusCode)))
                }
            }
            
            task.resume()
        }
    }
}
