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
    var Title: String
    var Year: String
    var Poster: String
}
