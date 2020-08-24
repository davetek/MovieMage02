//
//  NetworkManager.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func getMoviesInfoWithToken() {
        //prototype function for verifying connection to server & retrieval of data, w/access token
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
                
        guard let accessToken = ProcessInfo.processInfo.environment["TMAT"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "api.themoviedb.org"
        uc.path = "/3/movie/550"
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer: \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("Content-Type", forHTTPHeaderField: "application/json;charset=utf-8")
        
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error occurred when trying to get data using access token: \(error)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("response not retrieved")
                    return
                }
                print("response retrieved from request w acccess token: \(httpResponse.statusCode)")
                
                guard let data = data else {
                    print("no data retrieved")
                    return
                }
                
                if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                    DispatchQueue.main.async {
                        print(responseDataAsString)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func getMoviesInfo() {
        //prototype function for verifying connection to server & retrieval of data, w/API key
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
