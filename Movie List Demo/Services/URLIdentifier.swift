//
//  URLIdentifier.swift
//  Movie List Demo
//
//  Created by Kruti on 11/06/23.
//

import Foundation

struct URLIdentifier {
    static let baseURL = "https://api.themoviedb.org/3"
    static let movieDetailsListURL = "/trending/movie/day?language=en-US"
    static let imageeBaseURL = "https://image.tmdb.org/t/p/w200"
}
//"https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
//let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1")! as URL,
//https://api.themoviedb.org/3/discover/movie?language=en-US
