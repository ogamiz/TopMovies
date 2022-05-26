//
//  Movie.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 21/5/22.
//

import UIKit
import ObjectMapper

class Movie: Mappable
{
    internal var iId: Int?
    internal var iPopularity: Double?
    internal var iPosterPath: String?
    internal var iReleaseDate: String?
    internal var iTitle: String?
    internal var iVoteAverage: Double?
    //Extra
    internal var iPosterImage:UIImage?
    internal var iMovieDetail:MovieDetail?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iPopularity <- map["popularity"]
        iPosterPath <- map["poster_path"]
        iReleaseDate <- map["release_date"]
        iTitle <- map["title"]
        iVoteAverage <- map["vote_average"]
    }
}
