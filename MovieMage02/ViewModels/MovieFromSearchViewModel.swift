//
//  MovieFromSearchViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/29/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

class MovieFromSearchViewModel {
    
    enum GetImageForMovieError: Error {
        case errorNoImagePath(String)
        case errorGettingImageDataForImagePath(String)
    }
    
    private var movieFromSearch: MovieFromSearch
    private var networkManager: NetworkManager
    var retrievedPosterImage: Image?
    
    init(networkMgr: NetworkManager, movieFromSearchModel: MovieFromSearch) {
        movieFromSearch = movieFromSearchModel
        networkManager = networkMgr
        retrievedPosterImage = nil
    }
}

extension MovieFromSearchViewModel {
    
    var id: Int {
        return movieFromSearch.id
    }
    
    var posterPath: String? {
        return movieFromSearch.posterPath
    }
    
    var posterImage: Image? {
        return retrievedPosterImage
    }
    
    var releaseDate: String? {
        return movieFromSearch.releaseDate
    }
    
    var title: String {
        return movieFromSearch.title
    }
}

extension MovieFromSearchViewModel {
    
    func getImage(completionHandler: @escaping (Result<Image, GetImageForMovieError>) -> Void) {
        
        guard let posterPath = self.posterPath else {
            completionHandler(.failure(.errorNoImagePath("No poster image path for this movie.")))
            return
        }
         
         networkManager.getPosterImageData(forImagePath: posterPath, size: .w185) { (results) in
             switch results {
             case .success(let data):
                 if let image = Image(data: data) {
                    self.retrievedPosterImage = image
                     completionHandler(.success(image))
                 }
             case .failure(let networkError):
                 switch networkError {
                 case .errorNoResponse(let errorDescription):
                     let errorMsg = "Error: \(errorDescription)"
                     completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
                 case .errorWithResponse(let statusCode, let statusDescription):
                     let errorMsg = "Error: status code \(statusCode): \(statusDescription)"
                     completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
                 case .errorNoDataWithResponse(let statusCode, let statusDescription):
                     let errorMsg = "Error with no data: status code \(statusCode): \(statusDescription)"
                     completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
                 case .errorCouldNotDecodeData(let dataText):
                     let errorMsg = "Error: could not decode data received: \(dataText)"
                     completionHandler(.failure(.errorGettingImageDataForImagePath(errorMsg)))
                 }
             }
         }
     }
    
}
