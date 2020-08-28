//
//  MovieDetailsViewModel.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/27/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import UIKit

struct MovieDetailsViewModel {
    private let model: Movie
    
    init(model: Movie) {
        self.model = model
    }
}

extension MovieDetailsViewModel {
    var title: String {
        return model.title
    }
    
    var posterImageData: Data? {
        if let posterPath = model.posterPath {
            //TBD
        }
        return nil
    }
    
    var overview: String? {
        return model.overview
    }
    
    var runTime: Int? {
        return model.runtime
    }
}
