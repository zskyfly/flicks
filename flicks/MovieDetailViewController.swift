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

    @IBOutlet weak var poularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
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
            posterImageView.image = UIImage(named: "MissingPoster")
            releaseDateLabel.text = movie.getReleaseDate()
            poularityLabel.text = movie.getPopularity()
            
            if movie.posterPath != nil {
                let previewUrl = movie.getPosterImageUrl(Movie.PosterSize.Small.rawValue)
                let fullUrl = movie.getPosterImageUrl(Movie.PosterSize.Original.rawValue)

                posterImageView.setImageWithURLRequest(NSURLRequest(URL: fullUrl!), placeholderImage: UIImage(named: "MissingPoster"), success: nil, failure: { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                    self.posterImageView.setImageWithURL(previewUrl!)
                })
            }
        }
        self.resizeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resizeViews() {
        descriptionLabel.sizeToFit()
        infoView.frame.size.height = descriptionLabel.frame.height + titleLabel.frame.height + releaseDateLabel.frame.height + 36.0
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height + infoView.frame.origin.x)
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
