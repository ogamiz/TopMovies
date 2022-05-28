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
    internal var iBackdropPath: String?
    internal var iGenres: [Geners]?
    internal var iRuntime: Int?
    internal var iTagline: String?
    internal var iOverview: String?
    internal var iCredits:Credits?
    
    //Extra
    internal var iBackdropImage:UIImage?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iBackdropPath <- map["backdrop_path"]
        iGenres <- map["genres"]
        iRuntime <- map["runtime"]
        iTagline <- map["tagline"]
        iOverview <- map["overview"]
        iCredits <- map["credits"]
    }
}
