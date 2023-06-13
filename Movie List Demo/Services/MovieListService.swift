//
//  MovieListService.swift
//  Movie List Demo
//
//  Created by Kruti on 11/06/23.
//

import Foundation

protocol MovieListServiceProtocol {
    func getMovieListDetails(_ currentPage: Int, completion: @escaping (_ success: Bool, _ results: MovieDetailsListModel?, _ error: String?) -> ())
}

struct MovieListService: MovieListServiceProtocol {
    func getMovieListDetails(_ currentPage: Int, completion: @escaping (Bool, MovieDetailsListModel?, String?) -> ()) {
        let urlStr = URLIdentifier.baseURL + URLIdentifier.movieDetailsListURL
        HttpRequestHelper().GET(url: urlStr, params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(MovieDetailsListModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Movies to model")
                }
            } else {
                completion(false, nil, "Error: Teams GET Request failed")
            }
        }
    }
}
