//
//  Crew.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class Crew: Mappable
{
    internal var iId: Int?
    internal var iName: String?
    internal var iJob: String?
    internal var iDepartment: String?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iName <- map["name"]
        iJob <- map["job"]
        iDepartment <- map["department"]
    }
}
