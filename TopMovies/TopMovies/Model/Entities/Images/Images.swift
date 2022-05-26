//
//  Images.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class Images: Mappable
{
    internal var iId: Int?
    internal var iBackdrops: [Backdrops]?
    internal var iPosters: [Posters]?
    internal var iProfiles: [Profiles]?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iBackdrops <- map["backdrops"]
        iPosters <- map["posters"]
        iProfiles <- map["profiles"]
    }
}
