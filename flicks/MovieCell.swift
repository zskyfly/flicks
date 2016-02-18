//
//  MovieCell.swift
//  flicks
//
//  Created by Zachary Matthews on 2/16/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    var movie: Movie? {
        didSet {
            titleLabel.text = ""
            descriptionLabel.text = ""
            movieImageView.image = UIImage(named: "BlankPosterImage")
            if let movie = movie {
                titleLabel.text = movie.title
                descriptionLabel.text = movie.overview
                if let posterImageUrl = movie.getPosterImageUrl(Movie.PosterSize.Small.rawValue) {
                    movieImageView.setImageWithURL(posterImageUrl, placeholderImage: UIImage(named: "BlankPosterImage"))
                }
            }
            descriptionLabel.sizeToFit()
            if descriptionLabel.frame.height > 66.0 {
                descriptionLabel.frame.size = CGSize(width: descriptionLabel.frame.size.width, height: 66.0)
            }
        }
    }

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImageView.frame.size.width = 90.0
        movieImageView.frame.size.height = 90.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
