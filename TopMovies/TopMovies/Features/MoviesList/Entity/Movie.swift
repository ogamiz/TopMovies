//
//  Movie.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 21/5/22.
//

import UIKit
import ObjectMapper

public enum ImageStatusFetch
{
    case none
    case performing
    case complete
}

class Movie: Mappable
{
    internal var iAdult:String?
    internal var iBackdropPath:String?
    internal var iGenreIds: [Int]?
    internal var iId: Int?
    internal var iOriginalLanguage: String?
    internal var iOriginalTitle: String?
    internal var iOverview: String?
    internal var iPopularity: Double?
    internal var iPosterPath: String?
    internal var iReleaseDate: String?
    internal var iTitle: String?
    internal var iVideo: Bool?
    internal var iVoteAverage: Double?
    internal var iVoteCount: Int?
    //Extra
    internal var iPosterImage:UIImage?
    internal var iPosterImageStatus:ImageStatusFetch = .none
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        iAdult <- map["adult"]
        iBackdropPath <- map["backdrop_path"]
        iGenreIds <- map["genre_ids"]
        iId <- map["id"]
        iOriginalLanguage <- map["original_language"]
        iOriginalTitle <- map["original_title"]
        iOverview <- map["overview"]
        iPopularity <- map["popularity"]
        iPosterPath <- map["poster_path"]
        iReleaseDate <- map["release_date"]
        iTitle <- map["title"]
        iVideo <- map["video"]
        iVoteAverage <- map["vote_average"]
        iVoteCount <- map["vote_count"]
    }
}
