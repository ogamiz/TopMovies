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
    
}
