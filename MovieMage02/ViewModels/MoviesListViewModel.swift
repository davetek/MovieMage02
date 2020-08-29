//
//  MovieListViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

struct MoviesListViewModel {
    
    enum MoviesListError: Error {
        case errorRetrievingResults(String)
        case emptyResults(String)
    }
    
    enum MovieDetailsError: Error {
        case errorRetrievingResults(String)
    }
    
    enum MovieCreditsError: Error {
        case errorRetrievingResults(String)
        case errorEmptyCastList(String)
    }
    
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
    
    //passes id of movie retrieved to completion handler if successful; passes custom error if not
    func getMovie(withId id: Int, completionHandler: @escaping (Result<Int, MovieDetailsError>) -> Void) {
        
        networkManager.getMovie(withId: id) { (results) in
            switch results {
            case .success(let movie):
                completionHandler(.success(movie.id))
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    let errorMsg = "Error: \(errorDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorWithResponse(let statusCode, let statusDescription):
                    let errorMsg = "Error: status code \(statusCode): \(statusDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    let errorMsg = "Error with no data: status code \(statusCode): \(statusDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorCouldNotDecodeData(let dataText):
                    let errorMsg = "Error: could not decode data received: \(dataText)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                }
            }
        }
    }
    
    
    func getCredits(forMovieId id: Int, completionHandler: @escaping (Result<[Cast], MovieCreditsError>) -> Void) {
        
        networkManager.getCredits(forMovieId: id) { (results) in
            switch results {
            case .success(let credits):
                guard credits.cast.count > 0 else {
                    completionHandler(.failure(.errorEmptyCastList("Error: Cast list is empty for this movie.")))
                    return
                }
                //sort the cast list by order # and assign result to a variable
                //then remove all but the first n items (8?)
                //and convert this to an array of strings (cast name), which are the first n cast member names
                //and change the Result type passed to completion handler to [String]

                completionHandler(.success(credits.cast))
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
    
    //passes number of movies retrieved to completion handler if successful; passes custom error if not
    func searchForMovies(matching searchText: String, page: Int, completionHandler: @escaping (Result<Int, MoviesListError>) -> Void) {
        
        networkManager.search(for: .movies, matching: searchText, page: page) { (results) in
            switch results {
            case .success(let movieSearchResults):
                guard movieSearchResults.results.count > 0 else {
                    completionHandler(.failure(.emptyResults("Sorry, we couldn't find any movies matching your search terms")))
                    return
                }
                print("obtained \(movieSearchResults.totalResults) movie search results")
                print("for page \(movieSearchResults.page) of \(movieSearchResults.totalPages) total pages")
                print("movie search results 'results' array containing >= 0 movie from search instances:")
                print("\(movieSearchResults.results)")
                completionHandler(.success(movieSearchResults.totalResults))
            case .failure(let networkError):
                switch networkError {
                case .errorNoResponse(let errorDescription):
                    let errorMsg = "Error: \(errorDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorWithResponse(let statusCode, let statusDescription):
                    let errorMsg = "Error: status code \(statusCode): \(statusDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorNoDataWithResponse(let statusCode, let statusDescription):
                    let errorMsg = "Error with no data: status code \(statusCode) \(statusDescription)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                case .errorCouldNotDecodeData(let dataText):
                    let errorMsg = "Error: could not decode data received: \(dataText)"
                    completionHandler(.failure(.errorRetrievingResults(errorMsg)))
                }
            }
        }
    }
}
