//
//  NetworkManager.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func getMoviesInfo() {
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
        uc.path = "/3/movie/550"
        uc.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
                
        
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("did not receive response")
                    return
                }
                
                print("received response with status code: \(httpResponse.statusCode)")
                
                guard let data = data else {
                    print("did not receive data")
                    return
                }
                
                if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseDataAsString)
                }
            }
            
            task.resume()
        }
    }
}
