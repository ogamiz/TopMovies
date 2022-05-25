//
//  MovieDetail.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class MovieDetail: Mappable
{
    internal var iId: Int?
    internal var iPosterPath: String?
    internal var iReleaseDate: String?
    internal var iTitle: String?
    internal var iVoteAverage: Double?
    internal var iBackdropPath: String?
    internal var iGenres: [Int:String]?
    internal var iRuntime: Int?
    internal var iTagline: String?
 
    //Extra
    internal var iPosterImage:UIImage?
    internal var iBackdropImage:UIImage?
    internal var iCrew:[Crew]?
    internal var iCredits:[Credits]?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iPosterPath <- map["poster_path"]
        iReleaseDate <- map["release_date"]
        iTitle <- map["title"]
        iVoteAverage <- map["vote_average"]
        iBackdropPath <- map["backdrop_path"]
        iGenres <- map["genres"]
        iRuntime <- map["runtime"]
        iTagline <- map["tagline"]
    }
}
