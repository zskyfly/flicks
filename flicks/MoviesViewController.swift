//
//  MoviesViewController.swift
//  flicks
//
//  Created by Zachary Matthews on 2/16/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {

    var movies: [Movie]! = []

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.insertSubview(refreshControl, atIndex: 0)
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        errorView.hidden = true
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchMovies(refreshControl)
    }

    func displayError(error: NSError) {
        let errorMessage = error.localizedDescription
        self.errorLabel.text = errorMessage
        self.errorLabel.sizeToFit()
        // TODO: how to resize the containing imageView
        self.errorView.sizeToFit()
        self.errorView.hidden = false
    }

    func fetchMovies(refreshControl: UIRefreshControl? = nil) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMovies(
            { (newMovies) -> Void in
                self.movies = newMovies
                self.moviesTableView.reloadData()
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
                }
            }, error: { (error) -> Void in
                self.displayError(error!)
        })
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPathForCell(cell)
        let detailViewController = segue.destinationViewController as! MovieDetailViewController
        detailViewController.movie = self.movies[indexPath!.row]
    }

}

extension MoviesViewController: UITableViewDelegate {

}

extension MoviesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        cell.movie = self.movies[indexPath.row]
        return cell
    }
}