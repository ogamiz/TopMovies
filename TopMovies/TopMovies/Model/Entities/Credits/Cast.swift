//
//  Cast.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

public enum ImageStatus
{
    case fetching
    case completed
    case none
}

class Cast: Mappable
{
    internal var iId: Int?
    internal var iName: String?
    internal var iProfilePath:String?
    internal var iCharacter: String?
 
    //Extra
    internal var iProfileImage:UIImage?
    internal var iProfileImageStatus:ImageStatus = .none
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iId <- map["id"]
        iName <- map["name"]
        iProfilePath <- map["profile_path"]
        iCharacter <- map["character"]
    }
}
