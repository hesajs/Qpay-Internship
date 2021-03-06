//
//  FakeModel.swift
//  MovieList
//
//  Created by SaJesh Shrestha on 2/2/21.
//

import Foundation

struct Movies: Codable {
    var Search: [MovieProp]
}

struct MovieProp: Codable {
    var imdbID: String
    var movieTitle: String
    var year: String
    var posterImage: String
    
    enum CodingKeys: String, CodingKey {
        case imdbID
        case movieTitle = "Title"
        case year = "Year"
        case posterImage = "Poster"
    }
}
