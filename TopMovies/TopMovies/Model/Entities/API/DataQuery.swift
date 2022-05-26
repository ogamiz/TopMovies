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
    var iParameters:[String:String]
    
    required init(baseURL aBaseURL:String)
    {
        self.iBaseURL = aBaseURL
         
        var parameters:[String:String] = [:]
        parameters[Constants.QUERY_PARAMETER_API_KEY] = Constants.API_KEY
        self.iParameters = parameters
        
        super.init()
    }
    
    func addLanguageParameters()
    {
        self.iParameters[Constants.QUERY_PARAMETER_LANGUAGE] = Locale.current.languageCode
        self.iParameters[Constants.QUERY_PARAMETER_INCLUDE_LANGUAGES] = Locale.current.languageCode
    }
    
    func toString() -> String
    {
        var parametersString:String = "?"
        for (idx, parameter) in self.iParameters.enumerated() {
            parametersString += (parameter.key + "=" + parameter.value)
            if idx < self.iParameters.count
            {
                parametersString += "&"
            }
        }
        return (self.iBaseURL ?? "") + (self.iPath ?? "") + parametersString
    }
}
