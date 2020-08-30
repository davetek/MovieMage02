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
    
    enum GetImageDataForEachMovieInListError: Error {
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
    var moviesWithImageData: [MovieFromSearchWImageData] {
        return makeMoviesListForViewFromSearchResults(using: results)
    }
}

extension MoviesListViewModel {
    //functions to be used by view controller
    
    func makeMoviesListForViewFromSearchResults(using moviesFromSearch: [MovieFromSearch]) -> [MovieFromSearchWImageData] {
        //function guaranteed to return array of structs
        //should probably use Map for this
        
        var moviesListForView: [MovieFromSearchWImageData] = []
        
        if moviesFromSearch.count > 0 {
            for movie in moviesFromSearch {
                let movieForView = MovieFromSearchWImageData(id: movie.id, posterPath: movie.posterPath, posterImageData: nil, releaseDate: movie.releaseDate, title: movie.title)
                moviesListForView.append(movieForView)
            }
        }
        return moviesListForView
    }
    
//    func getAndSetPosterImageDataForEachMovie(inMovieList moviesList: inout [MovieFromSearchWImageData], completionHandler: @escaping (Result<Int, GetImageDataForEachMovieInListError>) -> Void) {
//        //function guaranteed to return array of structs
//
//        //for each struct, call getImageData network function to get the image data
//        // if successful, set the image data for the posterImageData property
//        // if this fails, set the posterImageData property to nil
//
//        if moviesList.count > 0 {
//            for i in moviesList.indices {
//                if let imagePath = moviesList[i].posterPath {
//                    networkManager.getPosterImageData(forImagePath: imagePath, size: .w185) { (results) in
//                        switch results {
//                        case .success(let data):
//                            moviesList[i].posterImageData = data
//                            print("successfully retrieved image data for image at path: \(imagePath)")
//                            let index = i
//                            completionHandler(.success(i))
//                        case .failure(let networkError):
//                            switch networkError {
//                            case .errorNoResponse(let errorDescription):
//                                let errorMsg = "Error: \(errorDescription)"
//                                completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
//                            case .errorWithResponse(let statusCode, let statusDescription):
//                                let errorMsg = "Error: status code \(statusCode): \(statusDescription)"
//                                completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
//                            case .errorNoDataWithResponse(let statusCode, let statusDescription):
//                                let errorMsg = "Error with no data: status code \(statusCode): \(statusDescription)"
//                                completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
//                            case .errorCouldNotDecodeData(let dataText):
//                                let errorMsg = "Error: could not decode data received: \(dataText)"
//                                completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
//                            }
//                        }
//                    }
//                } else {
//                    completionHandler(.failure(.errorNoImagePath("This movie has no poster image")))
//                }
//            }
//        } else {
//            completionHandler(.failure(.errorNoMoviesInList("Did not retrieve any images because movies list is empty")))
//        }
//    }
    
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
