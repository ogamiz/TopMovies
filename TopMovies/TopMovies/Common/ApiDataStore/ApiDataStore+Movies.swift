//
//  ApiDataStore+Movies.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import SwiftHTTP

extension ApiDataStore
{
    func fetchGetRequest(withDataQuery aDataQuery:DataQuery, onCompletionBlock:@escaping CompletionHandler)
    {
        Log.info(#function)
        let apiResponse:ApiResponse = ApiResponse(operationType: .failure,
                                                  responseType: .get)
        
        guard let baseURL:String = aDataQuery.iBaseURL,
              let path:String = aDataQuery.iPath,
              let parameters:[String:String] = aDataQuery.iParameters
        else
        {
            onCompletionBlock(apiResponse)
            return
        }
        
        let url:String = baseURL + path
        
        Log.info("Executing HTTP.GET...")
        HTTP.GET(url, parameters: parameters) { response in
            apiResponse.iStatusCode = response.statusCode
            
            if response.statusCode == 200
            {
                apiResponse.iOperationType = .succes
                apiResponse.iDataResults = response.data
            }
            else
            {
                if let error = response.error
                {
                    apiResponse.iError = error
                }
            }
            
            onCompletionBlock(apiResponse)
        }
    }
}
