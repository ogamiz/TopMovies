//
//  BaseInteractor.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log

class BaseInteractor: NSObject
{
    let iApiDataStore:ApiDataStore = ApiDataStore.sharedInstance
    let Log = Logger()
    
    func getDefaultParameters() -> [String:String]
    {
        var parameters:[String:String] = [:]
        parameters[Constants.QUERY_PARAMETER_API_KEY] = Constants.API_KEY
        parameters[Constants.QUERY_PARAMETER_LANGUAGE] = Locale.current.languageCode
        
        return parameters
    }
}
