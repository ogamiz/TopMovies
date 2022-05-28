//
//  ApiDataStore.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import SwiftHTTP
import Log

class ApiDataStore: NSObject
{
    //MARK: Singleton
    static let sharedInstance = ApiDataStore()
    private override init() {}
    
    let Log = Logger()
    
    //MARK: - Handlers
    typealias CompletionHandler = (ApiResponse) -> Void
    
    //MARK: - CRUD METHODS
    func fetchGetRequest(withDataQuery aDataQuery:DataQuery, onCompletionBlock:@escaping CompletionHandler)
    {
        let apiResponse:ApiResponse = ApiResponse(resultType: .failure,
                                                  responseType: .get)
        
        HTTP.GET(aDataQuery.iUrl, parameters: aDataQuery.iParameters) { response in
            apiResponse.iURL = response.URL
            apiResponse.iStatusCode = response.statusCode
            
            if response.statusCode == 200
            {
                apiResponse.iResultType = .succes
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
