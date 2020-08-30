//
//  MovieDetailsViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/27/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import UIKit

struct MovieDetailsViewModel {
    
    enum MovieDetailsError: Error {
        case errorRetrievingResults(String)
    }
    
    enum MovieCreditsError: Error {
        case errorRetrievingResults(String)
        case errorEmptyCastList(String)
    }
    
    private var networkManager: NetworkManager
    private var movie: Movie
    
    init(networkMgr: NetworkManager, movie: Movie) {
        self.networkManager = networkMgr
        self.movie = movie
    }
}

extension MovieDetailsViewModel {
    var title: String {
        return movie.title
    }
    
    var posterImageData: Data? {
        if let posterPath = movie.posterPath {
            //TBD
            // get the poster image
            return nil
        } else {
            return nil
        }
    }
    
    var overview: String? {
        if let overview = movie.overview {
            return overview
        } else {
            return nil
        }
    }
    
    var runTime: Int? {
        if let runtime = movie.runtime {
            return runtime
        } else {
            return nil
        }
    }
}

extension MovieDetailsViewModel {
    
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
}
