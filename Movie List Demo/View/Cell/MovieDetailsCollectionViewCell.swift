//
//  MovieDetailsCollectionViewCell.swift
//  Movie List Demo
//
//  Created by Kruti on 11/06/23.
//

import UIKit
import Network

class MovieDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieImageViewheight: NSLayoutConstraint!
    var networkCheck = NetworkCheck.sharedInstance()

    var movieImageData: Data? {
        didSet {
            if let imageData = movieImageData {
                self.movieImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    var logoImageURL: String? {
            didSet {
                let image = UIImage(named: "placeholder")
                if let url = logoImageURL {
                    UIImage.loadImageUsingCacheWithUrlString(url) { image in
                        if url == self.logoImageURL {
                            self.movieImageView.image = image
                        }
                    }
                }
                else {
                    self.movieImageView.image = image
                }
            }
        }
        
    func configure(movieTitle: String, movieImageString: String ) {
        movieTitleLabel.text = movieTitle
        logoImageURL = URLIdentifier.imageeBaseURL + movieImageString
    }
}
