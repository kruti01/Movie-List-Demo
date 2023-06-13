//
//  MovieListViewModel.swift
//  Movie List Demo
//
//  Created by Kruti on 11/06/23.
//

import UIKit


class MovieListViewModel {
    
    var movieList: [MovieList] = [MovieList]()
    var movieListFromDatabase: [MoviesData] = [MoviesData]()
    var reloadCollectionView: (()->())?
    var showError: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    let movieListService: MovieListService = MovieListService()
    var currentPage = 1
    var totalPages = 1
    
    private var cellViewModels: [MovieDetailsCellViewModel] = [MovieDetailsCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    func getMovieDetailsList(currentPage: Int) {
        showLoading?()
        movieListService.getMovieListDetails(currentPage) { success, results, error in
            self.hideLoading?()
            if success, let movieDetailsList = results?.results {
                self.totalPages = results?.totalPages ?? 1
               
                self.movieList.append(contentsOf: movieDetailsList)

                self.createCell(movieList: self.movieList)
                
                self.movieListFromDatabase = DatabaseHandler.shared.fetch(MoviesData.self)
                if self.movieListFromDatabase.count == 0 {
                    self.cellViewModels.forEach { $0.store()}
                }
                
                self.reloadCollectionView?()
            } else {
                print(error?.description ?? "")
                self.showError?()
            }
        }
    }
    
    func getMovieDetailsListFromDatabase() {
        self.movieListFromDatabase = DatabaseHandler.shared.fetch(MoviesData.self)
        if self.movieListFromDatabase.count > 0 {
            self.createCellfromDatabase(moviesData: self.movieListFromDatabase)
            
            self.reloadCollectionView?()
            
        } else {
            self.showError?()
        }
        
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieDetailsCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCell(movieList: [MovieList]){
        self.movieList = movieList
        var vms = [MovieDetailsCellViewModel]()
        for movieDetails in movieList {
            vms.append(MovieDetailsCellViewModel(id: movieDetails.id, movieTitleText: movieDetails.title, movieImageStr: movieDetails.posterPath, overview: movieDetails.overview, releaseDate: movieDetails.releaseDate, backdropPath: movieDetails.backdropPath))
        }
        cellViewModels = vms
    }
    
    func createCellfromDatabase(moviesData:  [MoviesData]) {
        var vms = [MovieDetailsCellViewModel]()
        for movieDetails in moviesData {
            vms.append(MovieDetailsCellViewModel(id: Int(movieDetails.id), movieTitleText: movieDetails.title ?? "", movieImageStr: movieDetails.posterPath ?? "", overview: movieDetails.overview ?? "", releaseDate: movieDetails.releaseDate ?? "", backdropPath: movieDetails.backdropPath ?? ""))
        }
        cellViewModels = vms
    }

}



