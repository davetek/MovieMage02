//
//  MovieListViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class MovieListViewModel {
    
    var networkManager: NetworkManager!
    
    init(networkMgr: NetworkManager) {
        networkManager = networkMgr
    }
    
    func getMoviesInfo() {
        var queryPath = "/3/movie/550"
        queryPath = "/3/movie/nnn"
        networkManager.getMoviesInfo(urlPathString: queryPath) { (resultStringOrError) in
            switch resultStringOrError {
            case .success(let data):
                print("received data:")
                print(data)
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    print("Error: \(errorDescription)")
                case .errorWithResponse(let statusCode, let statusDescription):
                    print("Error: status code \(statusCode): \(statusDescription)")
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    print("Error with no data: status code \(statusCode): \(statusDescription)")
                }
            }
        }
    }
    
    func searchForMovies(matching searchText: String, page: Int) {
        
        networkManager.search(for: .movies, matching: searchText, page: page) { (resultStringOrError) in
            
            switch resultStringOrError {
            case .success(let data):
                print("received data:")
                print(data)
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    print("Error: \(errorDescription)")
                case .errorWithResponse(let statusCode, let statusDescription):
                    print("Error: status code \(statusCode): \(statusDescription)")
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    print("Error with no data: status code \(statusCode): \(statusDescription)")
                }
            }
        }
    }
    

}
