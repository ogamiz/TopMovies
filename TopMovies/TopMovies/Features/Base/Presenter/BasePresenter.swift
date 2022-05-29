//
//  BasePresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log
import Reachability

class BasePresenter: NSObject
{
    let Log = Logger()
    var iReachability:Reachability = try! Reachability()
    
    func starNotifierReachability() -> CustomError?
    {
        do
        {
            try self.iReachability.startNotifier()
        }
        catch
        {
            Log.warning("Unable to start notifier")
            return CustomError.genericError
        }
        return nil
    }
    
    func stopNotifierReachability()
    {
        self.iReachability.stopNotifier()
    }
}
