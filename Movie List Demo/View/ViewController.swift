//
//  ViewController.swift
//  Movie List Demo
//
//  Created by Kruti on 10/06/23.
//

import UIKit
import Network

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataViewModel = MovieListViewModel()
    var networkCheck = NetworkCheck.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DatabaseHandler.shared.applicationDocumentsDirectory()
        setCollectionViewLayout()
        
        if networkCheck.currentStatus == .satisfied {
            initViewModel()
        } else {
            getDataFromDatabase()
        }
        networkCheck.addObserver(observer: self)
        
    }
    
    func initViewModel(){
        dataViewModel.reloadCollectionView = {
            DispatchQueue.main.async { self.collectionView.reloadData()            }
        }
        dataViewModel.showError = {
            DispatchQueue.main.async { self.showAlert("Ups, something went wrong.") }
        }
        dataViewModel.showLoading = {
            DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        }
        dataViewModel.hideLoading = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }
        }
        
        
        
        dataViewModel.getMovieDetailsList(currentPage: 1)
    }
    
    // MARK: - Get data from database
    func getDataFromDatabase() {
        dataViewModel.movieListFromDatabase = DatabaseHandler.shared.fetch(MoviesData.self)
        if dataViewModel.movieListFromDatabase.count > 0 {
            dataViewModel.createCellfromDatabase(moviesData: dataViewModel.movieListFromDatabase)
            
            dataViewModel.reloadCollectionView = {
                DispatchQueue.main.async { self.collectionView.reloadData()            }
            }
        } else {
            showAlert("Data not available.")
        }
    }

    // MARK: - Set collectionview layout
    func setCollectionViewLayout()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let screenWidth = collectionView.frame.size.width
        let size = screenWidth / 2 - 5
        layout.itemSize =  CGSize(width: size, height: 342)
        self.collectionView.collectionViewLayout = layout
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieDetailsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.movieDetailsCell, for: indexPath) as! MovieDetailsCollectionViewCell
        let cellVM = dataViewModel.getCellViewModel( at: indexPath )
        cell.configure(movieTitle: cellVM.movieTitleText, movieImageString: cellVM.movieImageStr)
        return cell
        
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if dataViewModel.currentPage < dataViewModel.totalPages && indexPath.item == dataViewModel.numberOfCells - 1 {
//            dataViewModel.currentPage += 1
//            print(dataViewModel.currentPage)
//            dataViewModel.getMovieDetailsList(currentPage: dataViewModel.currentPage)
//        }
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.movieDetails) as! MovieDetailsViewController
        if networkCheck.currentStatus == .satisfied {
            let selectedMovieDetails = dataViewModel.movieList[indexPath.item]

            vc.configure(selectedMovieDetails.backdropPath, selectedMovieDetails.title, selectedMovieDetails.releaseDate, selectedMovieDetails.overview)
        } else {
            let selectedMovieDetailsFromDatabase = dataViewModel.movieListFromDatabase[indexPath.item]

            vc.configure(selectedMovieDetailsFromDatabase.backdropPath ?? "", selectedMovieDetailsFromDatabase.title ?? "", selectedMovieDetailsFromDatabase.releaseDate ?? "", selectedMovieDetailsFromDatabase.overview ?? "")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Network status change method
extension ViewController: NetworkCheckObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            if dataViewModel.movieList.count > 0 {
                dataViewModel.reloadCollectionView = {
                    DispatchQueue.main.async { self.collectionView.reloadData()}
                }
            } else {
                initViewModel()
            }
        }else if status == .unsatisfied {
            getDataFromDatabase()
        }
    }
}
