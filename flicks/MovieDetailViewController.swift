//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Zachary Matthews on 2/16/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = self.movie {
            titleLabel.text = movie.title
            descriptionLabel.text = movie.overview
            if let posterImageUrl = movie.getPosterImageUrl(Movie.PosterSize.Small.rawValue) {
                posterImageView.setImageWithURL(posterImageUrl, placeholderImage: UIImage(named: "BlankPosterImage"))
            }
            if let posterImageUrl = movie.getPosterImageUrl(Movie.PosterSize.Original.rawValue) {
                posterImageView.setImageWithURL(posterImageUrl)
            }
        }
        descriptionLabel.sizeToFit()
        // TODO: how to sizeToFit the infoView container?
//        infoView.sizeToFit()
        infoView.frame.size.height = descriptionLabel.frame.height + titleLabel.frame.height + 24.0
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
