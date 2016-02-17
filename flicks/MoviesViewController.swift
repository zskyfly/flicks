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

    var movies = [Movie]()
    var isMoreDataLoading = false
    var currentPage: Int!
    var totalPages: Int!

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        errorView.hidden = true

        // add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.insertSubview(refreshControl, atIndex: 0)

        // add infinite scroll footer
        let tableFooterView: UIView = UIView(frame: CGRectMake(0, 0, 320, 50))
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.moviesTableView.tableFooterView = tableFooterView

        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchMovies(refreshControl: refreshControl)
    }

    func displayError(error: NSError) {
        let errorMessage = error.localizedDescription
        self.errorLabel.text = errorMessage
        self.errorLabel.sizeToFit()
        // TODO: how to resize the containing imageView
        self.errorView.sizeToFit()
        self.errorView.hidden = false
    }

    func fetchMovies(pageOffset: Int = 1, refreshControl: UIRefreshControl? = nil, replaceData: Bool = true) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMovies(
            pageOffset,
            successCallback: { (newMovies, currentPage, totalPages) -> Void in
                self.updateMovieDataStorage(newMovies, currentPage: currentPage, totalPages: totalPages, replaceData: replaceData)
                self.moviesTableView.reloadData()
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
                }
            },
            error: { (error) -> Void in
                self.displayError(error!)
            }
        )
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    func updateMovieDataStorage(newMovies: [Movie], currentPage: Int, totalPages: Int, replaceData: Bool) {
        if replaceData {
            self.movies = newMovies
        } else {
            self.movies.appendContentsOf(newMovies)
            self.isMoreDataLoading = false
        }
        self.currentPage = currentPage
        self.totalPages = totalPages
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
        return movies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        cell.movie = self.movies[indexPath.row]
        return cell
    }
}

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = moviesTableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.size.height
            if (scrollView.contentOffset.y > scrollViewOffsetThreshold && moviesTableView.dragging && self.currentPage < self.totalPages) {
                isMoreDataLoading = true
                fetchMovies(self.currentPage + 1, refreshControl: nil, replaceData: false)
            }
        }
    }
}