//
//  NetworkManager.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case errorWithResponse(Int, String) //assoc. values are status code, status descrip.
    case errorNoDataWithResponse(Int, String) //assoc. values are status code, status descrip.
    case errorNoResponse(String) // assoc. value is error localized descrip.
    case errorCouldNotDecodeData(String) //assoc. value is raw data text
}

class NetworkManager {
    
    enum SearchTarget: String {
        case movies = "/3/search/movie"
    }
    
    func search(for target: SearchTarget, matching searchText: String, page: Int, completionHandler: @escaping (Result<MovieSearchData, NetworkError>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
        guard let apiKey = ProcessInfo.processInfo.environment["TMAK"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "api.themoviedb.org"
        uc.path = target.rawValue
        uc.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "query", value: searchText)]
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                
                //set the response, or if no response, execute closure w/ .failure case 'errorNoResponse'
                guard let httpResponse = response as? HTTPURLResponse else {
                    if let error = error {
                        completionHandler(.failure(.errorNoResponse(error.localizedDescription)))
                    } else {
                        completionHandler(.failure((.errorNoResponse("Network request failed without an error from the system"))))
                    }
                    return
                }
                
                //verify that response status code is successful; if not, execute closure w/.failure case 'errorWithResponse'
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                //Set the data var, or if no data even though successful response code was returned, execute closure w/.failure case 'errorNoDataWithResponse'
                guard let data = data else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorNoDataWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                let decoder = JSONDecoder()
                
                
                do {
                    //                    if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                    //                        print(responseDataAsString)
                    //                    }
                    let movieSearchData = try decoder.decode(MovieSearchData.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(movieSearchData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                            completionHandler(.failure(.errorCouldNotDecodeData(responseDataAsString)))
                        } else {
                            completionHandler(.failure(.errorCouldNotDecodeData("")))
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func getMovie(withId id: Int, completionHandler: @escaping (Result<Movie, NetworkError>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
        guard let apiKey = ProcessInfo.processInfo.environment["TMAK"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "api.themoviedb.org"
        uc.path = "/3/movie/\(id)"
        uc.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                
                //set the response, or if no response, execute closure w/ .failure case 'errorNoResponse'
                guard let httpResponse = response as? HTTPURLResponse else {
                    if let error = error {
                        completionHandler(.failure(.errorNoResponse(error.localizedDescription)))
                    } else {
                        completionHandler(.failure((.errorNoResponse("Network request failed without an error from the system"))))
                    }
                    return
                }
                
                //verify that response status code is successful; if not, execute closure w/.failure case 'errorWithResponse'
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                //Set the data var, or if no data even though successful response code was returned, execute closure w/.failure case 'errorNoDataWithResponse'
                guard let data = data else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorNoDataWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                let decoder = JSONDecoder()
                
                
                do {
                    if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseDataAsString)
                    }
                    let movie = try decoder.decode(Movie.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(movie))
                    }
                } catch {
                    DispatchQueue.main.async {
                        if let responseDataAsString = String(data: data, encoding: String.Encoding.utf8) {
                            completionHandler(.failure(.errorCouldNotDecodeData(responseDataAsString)))
                        } else {
                            completionHandler(.failure(.errorCouldNotDecodeData("")))
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    func getImageData(forImagePath imagePath: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: sessionConfig)
        
        guard let apiKey = ProcessInfo.processInfo.environment["TMAK"] else {
            print("could not retrieve environment variable value")
            return
        }
        
        var pathAPIVersionPrefix = "/3/"
        var tempImagePath = "eVPs2Y0LyvTLZn6AP5Z6O2rtiGB.jpg"
        
        var uc = URLComponents()
        uc.scheme = "https"
        uc.host = "api.themoviedb.org"
        uc.path = pathAPIVersionPrefix + tempImagePath
        uc.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = uc.url else {
            print("could not form url from components")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                
                //set the response, or if no response, execute closure w/ .failure case 'errorNoResponse'
                guard let httpResponse = response as? HTTPURLResponse else {
                    if let error = error {
                        completionHandler(.failure(.errorNoResponse(error.localizedDescription)))
                    } else {
                        completionHandler(.failure((.errorNoResponse("Network request failed without an error from the system"))))
                    }
                    return
                }
                
                //verify that response status code is successful; if not, execute closure w/.failure case 'errorWithResponse'
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                //Set the data var, or if no data even though successful response code was returned, execute closure w/.failure case 'errorNoDataWithResponse'
                guard let data = data else {
                    let statusCode = httpResponse.statusCode
                    let statusCodeString = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completionHandler(.failure(.errorNoDataWithResponse(statusCode, statusCodeString)))
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            }
            task.resume()
        }
    }
    
    
    
    
    
}
