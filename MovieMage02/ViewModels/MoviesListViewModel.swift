//
//  MovieListViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

struct MoviesListViewModel {
    
    var networkManager: NetworkManager!
    
    init(networkMgr: NetworkManager) {
        networkManager = networkMgr
    }
}

extension MoviesListViewModel {
    //properties to be accessed by view controller
    
//    var totalResults: Int
//    var totalPages: Int
//    var moviesList: [MovieDetailsViewModel]
}

extension MoviesListViewModel {
    //functions to be used by view controller
    
    func getMovie(withId id: Int, completionHandler: @escaping () -> Void) {
        
        networkManager.getMovie(withId: id) { (results) in
            switch results {
            case .success(let movie):
                //TO DO: create a MovieForView model instance from Movie info & pass to comp. handler
                print("obtained movie info for \(movie.title)")
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    print("Error: \(errorDescription)")
                case .errorWithResponse(let statusCode, let statusDescription):
                    print("Error: status code \(statusCode): \(statusDescription)")
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    print("Error with no data: status code \(statusCode): \(statusDescription)")
                case .errorCouldNotDecodeData(let dataText):
                    print("Error: could not decode data received: \(dataText)")
                }
            }
        }
    }
    

    func searchForMovies(matching searchText: String, page: Int) {
        
        networkManager.search(for: .movies, matching: searchText, page: page) { (results) in
            switch results {
            case .success(let movieSearchResults):
                print("obtained \(movieSearchResults.totalResults) movie search results")
                print("for page \(movieSearchResults.page) of \(movieSearchResults.totalPages) total pages")
                print("movie search results 'results' array containing >= 0 movie from search instances:")
                print("\(movieSearchResults.results)")
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    print("Error: \(errorDescription)")
                case .errorWithResponse(let statusCode, let statusDescription):
                    print("Error: status code \(statusCode): \(statusDescription)")
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    print("Error with no data: status code \(statusCode): \(statusDescription)")
                case .errorCouldNotDecodeData(let dataText):
                    print("Error: could not decode data received: \(dataText)")
                }
            }
        }
    }
}
