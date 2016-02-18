//
//  Movie.swift
//  flicks
//
//  Created by Zachary Matthews on 2/16/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import AFNetworking
import Foundation

private let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
private let moviesBaseUrl = "https://api.themoviedb.org/3/movie/"
private let imageBaseUrl = "http://image.tmdb.org/t/p/"


class Movie {

    enum PosterSize: String {
        case Small = "w154"
        case Medium = "w500"
        case Large = "w780"
        case Original = "original"
    }

    enum Endpoint: String {
        case NowPlaying = "now_playing"
        case TopRated = "top_rated"
    }

    var posterPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int]?
    var id: Int?
    var originalTitle: String?
    var originalLanguage: String?
    var title: String?
    var backdropPath: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Float?

    init(jsonResult: NSDictionary) {
        if let posterPath = jsonResult["poster_path"] as? String {
            self.posterPath = posterPath
        }
        if let adult = jsonResult["adult"] as? Bool {
            self.adult = adult
        }
        if let overview = jsonResult["overview"] as? String {
            self.overview = overview
        }
        if let releaseDate = jsonResult["release_date"] as? String {
            self.releaseDate = releaseDate
        }
        if let genreIds = jsonResult["genre_ids"] as? [Int] {
            self.genreIds = genreIds
        }
        if let id = jsonResult["id"] as? Int {
            self.id = id
        }
        if let originalTitle = jsonResult["original_title"] as? String {
            self.originalTitle = originalTitle
        }
        if let originalLanguage = jsonResult["original_language"] as? String {
            self.originalLanguage = originalLanguage
        }
        if let title = jsonResult["title"] as? String {
            self.title = title
        }
        if let backdropPath = jsonResult["backdrop_path"] as? String {
            self.backdropPath = backdropPath
        }
        if let popularity = jsonResult["popularity"] as? Double {
            self.popularity = popularity
        }
        if let voteCount = jsonResult["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        if let voteCount = jsonResult["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        if let video = jsonResult["video"] as? Bool {
            self.video = video
        }
        if let voteAverage = jsonResult["vote_average"] as? Float {
            self.voteAverage = voteAverage
        }
    }

    func getPosterImageUrl(size: String) -> NSURL? {
        if let posterPath = self.posterPath {
            let fullUrl = imageBaseUrl + size + posterPath
            return NSURL(string: fullUrl)
        }
        return nil
    }

    func getReleaseDate() -> String {
        if let releaseDate = self.releaseDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(releaseDate)
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            return dateFormatter.stringFromDate(date!)
        }
        return "unavailable"
    }

    func getPopularity() -> String {
        if let popularity = self.popularity {
            return String(format: "%.1f%%", popularity)
        }
        return "unavailable"
    }

    class func fetchMovies(endpoint: String = Movie.Endpoint.NowPlaying.rawValue, page: Int = 1, successCallback: ([Movie], currentPage: Int, totalPages: Int) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        let url = moviesBaseUrl + endpoint
        let params = ["api_key": apiKey, "page": String(page)]

        manager.GET(url, parameters: params, success: { (operation, responseObject) -> Void in

            if let results = responseObject["results"] as? NSArray {
                let currentPage = responseObject["page"] as! Int
                let totalPages = responseObject["total_pages"] as! Int
                var movies: [Movie] = []
                for result in results as! [NSDictionary] {
                    movies.append(Movie(jsonResult: result))
                }
                successCallback(movies, currentPage: currentPage, totalPages: totalPages)
            }
            }, failure: { (operation, requestError) -> Void in
                if let errorCallback = error {
                    errorCallback(requestError)
                }
        })
    }

}

extension Movie: CustomStringConvertible {
    var description: String {
        return "\n\t[posterPath: \(self.posterPath)]" +
            "\n\t[adult: \(self.adult)]" +
            "\n\t[overview: \(self.overview)]" +
            "\n\t[releaseDate: \(self.releaseDate)]" +
            "\n\t[genreIds: \(self.genreIds)]" +
            "\n\t[id: \(self.id)]" +
            "\n\t[originalTitle: \(self.originalTitle)]" +
            "\n\t[originalLanguage: \(self.originalLanguage)]" +
            "\n\t[title: \(self.title)]" +
            "\n\t[backdropPath: \(self.backdropPath)]" +
            "\n\t[popularity: \(self.popularity)]" +
            "\n\t[voteCount: \(self.voteCount)]" +
            "\n\t[video: \(self.video)]" +
            "\n\t[voteAverage: \(self.voteAverage)]"
    }
}
