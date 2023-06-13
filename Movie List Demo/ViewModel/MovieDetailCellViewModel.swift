//
//  MovieDetailCellViewModel.swift
//  Movie List Demo
//
//  Created by Kruti on 12/06/23.
//

import Foundation

struct MovieDetailsCellViewModel: Hashable {
    let id: Int
    let movieTitleText: String
    let movieImageStr: String
    let overview: String
    let releaseDate: String
    let backdropPath: String
    
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        static func ==(lhs: MovieDetailsCellViewModel, rhs: MovieDetailsCellViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        
        static let database = DatabaseHandler.shared
        func store() {
            guard let match = MovieDetailsCellViewModel.database.add(MoviesData.self) else {return}
            match.overview = overview
            match.title = movieTitleText
            match.releaseDate = releaseDate
            match.backdropPath = backdropPath
            match.posterPath = movieImageStr

            MovieDetailsCellViewModel.database.save()
        }
}
