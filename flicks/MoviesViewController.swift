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
    var filteredMovies = [Movie]()
    var isMoreDataLoading = false
    var currentPage: Int = 0
    var totalPages: Int = 0
    var endpoint: String!
    var searchBar: UISearchBar!
    var isSearchActive: Bool = false

    @IBOutlet weak var layoutSegmentedControl: UISegmentedControl!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesCollectionView.delegate = self
        self.moviesCollectionView.dataSource = self
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

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        fetchMovies(self.endpoint)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchMovies(self.endpoint, refreshControl: refreshControl)
    }

    @IBAction func onLayoutChange(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
            case 0:
                self.moviesCollectionView.hidden = true
                self.moviesTableView.hidden = false
            case 1:
                self.moviesCollectionView.hidden = false
                self.moviesTableView.hidden = true
            default:
                break
        }
        self.reloadViewData()
    }
    private func displayError(error: NSError) {
        let errorMessage = error.localizedDescription
        self.errorLabel.text = errorMessage
        self.errorLabel.sizeToFit()
        self.errorView.sizeToFit()
        self.errorView.frame.size.height = errorLabel.frame.height + (2 * errorLabel.frame.origin.y)
        self.errorView.hidden = false
    }

    private func fetchMovies(endPoint: String, pageOffset: Int = 1, refreshControl: UIRefreshControl? = nil, replaceData: Bool = true) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMovies(
            self.endpoint,
            page: pageOffset,
            successCallback: { (newMovies, currentPage, totalPages) -> Void in
                self.updateMovieDataStorage(newMovies, currentPage: currentPage, totalPages: totalPages, replaceData: replaceData)
                self.reloadViewData()
                self.errorView.hidden = true
                if let refreshControl = refreshControl {
                    refreshControl.endRefreshing()
                }
            },
            error: { (error) -> Void in
                self.displayError(error!)
                self.isMoreDataLoading = false
            }
        )
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    private func toggleControls() {
        if self.isSearchActive {
            moviesTableView.tableFooterView?.hidden = true
        } else {
            moviesTableView.tableFooterView?.hidden = false
        }
    }

    private func reloadViewData() {
        let selectedIndex = self.layoutSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
        self.moviesTableView.reloadData()
        case 1:
            self.moviesCollectionView.reloadData()
        default:
            break
        }
    }

    private func updateMovieDataStorage(newMovies: [Movie], currentPage: Int, totalPages: Int, replaceData: Bool) {
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
        self.searchBar.resignFirstResponder()
        let vc = segue.destinationViewController as! MovieDetailViewController
        vc.hidesBottomBarWhenPushed = true

        if let identifier = segue.identifier {
            switch identifier {
                case "MovieCollectionCellSegue":
                    let cell = sender as! UICollectionViewCell
                    let indexPath = self.moviesCollectionView.indexPathForCell(cell)
                    vc.movie = self.getMovies()[indexPath!.row]
                    moviesCollectionView.deselectItemAtIndexPath(indexPath!, animated: false)
                case "MovieTableCellSegue":
                    let cell = sender as! UITableViewCell
                    let indexPath = self.moviesTableView.indexPathForCell(cell)
                    vc.movie = self.getMovies()[indexPath!.row]
                    moviesTableView.deselectRowAtIndexPath(indexPath!, animated: false)
                default:
                    return
            }
        }
    }
}

extension MoviesViewController: UITableViewDelegate {}

extension MoviesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getMovies().count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        cell.movie = self.getMovies()[indexPath.row]
        return cell
    }

    private func getMovies() -> [Movie] {
        if self.isSearchActive {
            return self.filteredMovies
        }
        return self.movies
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMovies().count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        cell.movie = self.getMovies()[indexPath.row]
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegate {}

extension MoviesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!self.isMoreDataLoading && !self.isSearchActive) {
            let scrollViewContentHeight = moviesTableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.size.height
            let isMoreDataAvailable = self.currentPage < self.totalPages
            let isOneScreenFromBottom = scrollView.contentOffset.y > scrollViewOffsetThreshold
            if (isMoreDataAvailable && isOneScreenFromBottom && moviesTableView.dragging) {
                isMoreDataLoading = true
                let nextPage = self.currentPage + 1
                fetchMovies(self.endpoint, pageOffset: nextPage, refreshControl: nil, replaceData: false)
            }
        }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.isSearchActive = false
        self.reloadViewData()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearchActive = false
        } else {
            self.isSearchActive = true

            self.filteredMovies = self.movies.filter({ (movie) -> Bool in
                if let movieTitle: String = movie.title {
                    if movieTitle.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        return true
                    }
                }
                return false
            })
        }
        self.reloadViewData()
        self.toggleControls()
    }
}
