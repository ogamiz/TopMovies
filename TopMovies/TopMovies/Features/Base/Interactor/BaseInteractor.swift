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
    
    func showResponseError(_ aError:Error?)
    {
        if let error = aError
        {
            self.Log.warning("Error from API:")
            self.Log.error(error)
        }
        else
        {
            self.Log.warning("API ERROR WITHOUT MESSAGE!")
        }
    }
    
    //MARK: - Fetch API Methods
    func fetchImageResource(forPath aPath:String, withPathSize aSize:String, onCompletionBlock:@escaping (UIImage?) -> Void)
    {
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL_IMAGES+aSize)
        dataQuery.iPath = aPath
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: dataQuery) { apiResponse in
            if apiResponse.iResultType == .succes
            {
                if let imageData = apiResponse.iDataResults
                {
                    let image = UIImage(data: imageData)
                    onCompletionBlock(image)
                }
                else
                {
                    self.Log.warning("NO DATA RESULTS FOR IMAGE: \(aPath)")
                    onCompletionBlock(nil)
                }
            }
            else
            {
                self.showResponseError(apiResponse.iError)
                onCompletionBlock(nil)
            }
        }
    }
}
