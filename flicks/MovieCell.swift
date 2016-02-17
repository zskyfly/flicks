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
            if let movie = movie {
                titleLabel.text = movie.title
                descriptionLabel.text = movie.overview
                movieImageView.setImageWithURL(movie.listImageUrl!)
            }
        }
    }

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
