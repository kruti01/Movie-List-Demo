//
//  MovieDetailsViewController.swift
//  Movie List Demo
//
//  Created by Kruti on 12/06/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
 
    var movieTitle: String = ""
    var releaseDate: String = ""
    var overview: String = ""
    var backdropPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }

    func configure(_ backdropPath: String, _ movieTitle: String, _ releaseDate: String, _ overview: String) {
        self.movieTitle = movieTitle
        self.releaseDate = releaseDate
        self.overview = overview
        self.backdropPath = backdropPath
    }
    
    func setupview() {
        UIImage.loadImageUsingCacheWithUrlString(URLIdentifier.imageeBaseURL + backdropPath) { image in
                self.moviePosterImageView.image = image
        }
        movieTitleLabel.text = movieTitle
        movieReleaseDateLabel.text = "Released on:\(releaseDate)"
        movieOverviewLabel.text = overview
    }
    
    
    @IBAction func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


}
