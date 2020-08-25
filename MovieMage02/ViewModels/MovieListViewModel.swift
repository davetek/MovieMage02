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
    
    func printMoviesInfo() {
//        let queryPath = "/3/movie/nnn"
        let queryPath = "/3/movie/530"
        networkManager.getMoviesInfo(urlPathString: queryPath) { [weak self] result in
            switch result {
            case .success(let retrievedData):
                if let data = retrievedData.0 {
                    if let responseCode = retrievedData.1 {
                        print("received response code: \(responseCode)")
                        print("received data: \(data)")
                    } else {
                        print("received data: \(data)")
                    }
                } else if let responseCode = retrievedData.1 {
                    print("received response code: \(responseCode)")
                }

            case .failure(let error):
                print("ERROR!")
                print(error.localizedDescription)
            }
        }
    }
}
