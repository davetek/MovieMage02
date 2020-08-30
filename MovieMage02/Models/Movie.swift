//
//  Movie.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/26/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

struct Movie: Codable {

    var genres: [Genre]?
    var id: Int
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var title: String
    var runtime: Int?
    
    //not in TMDB Movie resource
    var credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case genres
        case id
        case posterPath = "poster_path"
        case title
        case overview
        case runtime
        case releaseDate = "release_date"
    }
    
}
