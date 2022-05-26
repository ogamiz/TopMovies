//
//  Geners.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit

import ObjectMapper

class Geners: Mappable
{
    internal var iId: Int?
    internal var iName: String?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iName <- map["name"]
    }
}
