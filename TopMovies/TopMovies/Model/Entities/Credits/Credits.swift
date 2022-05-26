//
//  Credits.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class Credits: Mappable
{
    internal var iCast:[Cast]?
    internal var iCrew:[Crew]?
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iCast <- map["cast"]
        iCrew <- map["crew"]
    }
}
