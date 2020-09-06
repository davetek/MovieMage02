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
    private var moviesFromSearchWithImages: [MovieFromSearchViewModel]
    private var lastSearchTextSubmitted: String?
    
    init(networkMgr: NetworkManager) {
        networkManager = networkMgr
        movieSearchData = MovieSearchData(page: 0, totalResults: 0, totalPages: 0, results: [MovieFromSearch]())
        moviesFromSearchWithImages = [MovieFromSearchViewModel]()
    }
}

extension MoviesListViewModel {
    //properties to be accessed by view controller
    //properties to be supplied by
    
    var searchText: String? {
        return lastSearchTextSubmitted
    }
    
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
        return moviesFromSearchWithImages
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
    
    func clearSearchDataAndResults () {
        movieSearchData = MovieSearchData(page: 0, totalResults: 0, totalPages: 0, results: [MovieFromSearch]())
    }
    
    func makeMoviesListForViewFromSearchResults(using moviesFromSearch: [MovieFromSearch]) -> Void {
        //function guaranteed to return array of structs
        //should probably use Map for this
        
        var moviesListForView: [MovieFromSearchViewModel] = []
        
        if moviesFromSearch.count > 0 {
            for movie in moviesFromSearch {
                let movieForView = MovieFromSearchViewModel(networkMgr: networkManager, movieFromSearchModel: movie)
                
                moviesListForView.append(movieForView)
            }
        }
        moviesFromSearchWithImages = moviesListForView
    }
    
 
    //passes number of movies retrieved to completion handler if successful; passes custom error if not
    func searchForMovies(matching searchText: String, page: Int, completionHandler: @escaping (Result<Int, MoviesListError>) -> Void) {
        
        networkManager.search(for: .movies, matching: searchText, page: page) { [weak self](results) in
            
            guard let self = self else {
                return
            }
            
            switch results {
            case .success(let movieSearchResults):
                guard movieSearchResults.results.count > 0 else {
                    completionHandler(.failure(.emptyResults("Sorry, we couldn't find any movies matching your search terms")))
                    return
                }
                //clear current search data
                self.clearSearchDataAndResults()
                
                self.lastSearchTextSubmitted = searchText
                
                print("obtained \(movieSearchResults.totalResults) movie search results")
                print("for page \(movieSearchResults.page) of \(movieSearchResults.totalPages) total pages")
                print("movie search results 'results' array containing >= 0 movie from search instances:")
                print("\(movieSearchResults.results)")
                
                self.movieSearchData = movieSearchResults
                
                //create the array of movie view models for use by the view controller
                self.makeMoviesListForViewFromSearchResults(using: self.movieSearchData.results)

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
