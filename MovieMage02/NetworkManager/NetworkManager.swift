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
        //prototype function for verifying connection to server & retrieval of data
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
//        let baseURLString = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc"
                
        guard let apiKey = ProcessInfo.processInfo.environment["TMAK"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        let urlBaseString = "https://api.themoviedb.org/3/movie/550"
        
        guard let url = URL(string: urlBaseString + "?api_key=" + apiKey) else {
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
