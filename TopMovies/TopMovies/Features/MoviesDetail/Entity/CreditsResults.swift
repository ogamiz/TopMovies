//
//  CreditsResults.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class CreditsResults: Mappable
{
    internal var iCast:[Credits]?
    internal var iCrew:[Crew]?
    internal var iID:Int?
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iCast <- map["id"]
        iCrew <- map["crew"]
        iID <- map["cast"]
    }
}
