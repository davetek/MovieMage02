//
//  MovieListViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class MoviesListViewModel {
    
    enum MoviesListError: Error {
        case errorRetrievingResults(String)
        case emptyResults(String)
    }
    
    enum GetImagesForMoviesError: Error {
        case errorNoMoviesInList(String)
        case errorNoImagePath(String)
        case errorGettingImageDataForImagePath(String)
    }
    
    var networkManager: NetworkManager
    private var movieSearchData: MovieSearchData
    
    init(networkMgr: NetworkManager) {
        networkManager = networkMgr
        movieSearchData = MovieSearchData(page: 0, totalResults: 0, totalPages: 0, results: [])
    }
}

extension MoviesListViewModel {
    //properties to be accessed by view controller
    //properties to be supplied by
    var page: Int {
        return movieSearchData.page
    }
    var totalResults: Int {
        return movieSearchData.totalResults
    }
    var totalPages: Int {
        return movieSearchData.totalPages
    }
    var results: [MovieFromSearch] {
        return movieSearchData.results
    }
    var moviesWithImageData: [MovieFromSearchViewModel] {
        return makeMoviesListForViewFromSearchResults(using: results)
    }
}

extension MoviesListViewModel {
    //functions to be used by view controller
    
    func getAndSetImageForEachMovie(completionHandler: @escaping (Result<Int, GetImagesForMoviesError>) -> Void) {
        
        guard moviesWithImageData.count > 0 else {
            completionHandler(.failure(.errorNoMoviesInList("No movies in list")))
            return
        }
        
        for movie in moviesWithImageData.enumerated() {
            
            movie.element.getImage { (results) in
                switch results {
                case .success(_):
                    completionHandler(.success(movie.offset))
                case .failure(let error):
                    switch error {
                    case .errorNoImagePath(let errorMsg):
                        print(errorMsg)
                    case .errorGettingImageDataForImagePath(let errorMsg):
                        print(errorMsg)
                    }
                }
            }
        }
    }
    
    func makeMoviesListForViewFromSearchResults(using moviesFromSearch: [MovieFromSearch]) -> [MovieFromSearchViewModel] {
        //function guaranteed to return array of structs
        //should probably use Map for this
        
        var moviesListForView: [MovieFromSearchViewModel] = []
        
        if moviesFromSearch.count > 0 {
            for movie in moviesFromSearch {
                let movieForView = MovieFromSearchViewModel(networkMgr: networkManager, movieFromSearchModel: movie)
                
                moviesListForView.append(movieForView)
            }
            
        }
        return moviesListForView
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
                self.movieSearchData = movieSearchResults
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
