//
//  DataQuery.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

public class DataQuery: NSObject
{
    var iUrl:String
    {
        get
        {
            return self.iBaseURL + self.iPath
        }
    }
    var iBaseURL:String
    var iPath:String
    var iParameters:[String:String]
    
    required init(baseURL aBaseURL:String, path aPath:String)
    {
        self.iBaseURL = aBaseURL
        self.iPath = aPath
        
        var parameters:[String:String] = [:]
        parameters[Constants.QUERY_PARAMETER_API_KEY] = Constants.API_KEY
        self.iParameters = parameters
        
        super.init()
    }
    
    func addPage(_ aPage:Int)
    {
        self.iParameters[Constants.QUERY_PARAMETER_PAGE] = String(aPage)
    }
    func addQueryString(_ aQueryString:String)
    {
        self.iParameters[Constants.QUERY_PARAMETER_QUERY] = aQueryString
    }
    func addLanguage()
    {
        self.iParameters[Constants.QUERY_PARAMETER_LANGUAGE] = Locale.current.languageCode
    }
    func addRegion()
    {
        self.iParameters["region"] = Locale.current.regionCode
    }
    func addQueryAppend(_ aQueryAppend:String)
    {
        if var queryAppend = self.iParameters[Constants.QUERY_PARAMETER_APPEND]
        {
            queryAppend += ",\(aQueryAppend)"
            self.iParameters[Constants.QUERY_PARAMETER_APPEND] = queryAppend
        }
        else
        {
            self.iParameters[Constants.QUERY_PARAMETER_APPEND] = aQueryAppend
        }
    }
    func toString() -> String
    {
        var parametersString:String = "?"
        for (idx, parameter) in self.iParameters.enumerated() {
            parametersString += (parameter.key + "=" + parameter.value)
            if idx < self.iParameters.count-1
            {
                parametersString += "&"
            }
        }
        return self.iBaseURL + self.iPath + parametersString
    }
}
