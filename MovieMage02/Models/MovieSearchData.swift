//
//  MovieSearchData.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/26/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import Foundation

struct MovieSearchData: Codable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [MovieFromSearch]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
