//
//  Backdrops.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 25/5/22.
//

import UIKit
import ObjectMapper

class Backdrops: Mappable
{
    internal var iAspectRatio: Double?
    internal var iFilePath: String?
    internal var iHeight: Int?
    internal var iWidth: Int?
    
    required init?(map:Map)
    {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        iAspectRatio <- map["aspect_ratio"]
        iFilePath <- map["file_path"]
        iHeight <- map["height"]
        iWidth <- map["width"]
    }
}
