//
//  DataQuery.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

class DataQuery: NSObject
{
    var iBaseURL:String?
    var iPath:String?
    var iParameters:[String:String]?
    
    required init(baseURL aBaseURL:String)
    {
        self.iBaseURL = aBaseURL
        super.init()
    }
}
