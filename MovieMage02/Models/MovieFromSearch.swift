//
//  MovieFromSearch.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/26/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

struct MovieFromSearch: Codable {
    var id: Int
    var posterPath: String?
    var releaseDate: String?
    var title: String
        
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}
