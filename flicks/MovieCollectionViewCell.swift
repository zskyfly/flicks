//
//  MovieCollectionViewCell.swift
//  flicks
//
//  Created by Zachary Matthews on 2/17/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    var movie: Movie? {
        didSet {
            if let movie = movie {
                if let movieImageUrl = movie.getPosterImageUrl(Movie.PosterSize.Small.rawValue) {
                    movieImageView.setImageWithURL(movieImageUrl)
                }
            }
        }
    }
}
