//
//  MovieListResults.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import ObjectMapper

class MovieListResults: Mappable
{
    internal var iResults:[Movie]?
    internal var iTotalPages:Int?
    internal var iTotalResults: Int?
    internal var iPage: Int?
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        iResults <- map["results"]
        iTotalPages <- map["total_pages"]
        iTotalResults <- map["total_results"]
        iPage <- map["page"]
    }
}
