//
//  BasePresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log
import Reachability

public enum CustomError: Error
{
    // Throw when App is not connected to internet
    case noConnection

    // Throw when an expected resource is not found
    case notResourceFound
    
    // Throw when detectd any expected error
    case genericError
    
    // Throw in all other cases
    case unexpected
    
    public var description: String
    {
        switch self
        {
        case .noConnection:
            return "App is not connected to internet."
        case .notResourceFound:
            return "The specified item could not be found."
        case .genericError:
            return "Detected a generic Error."
        case .unexpected:
            return "An unexpected error occurred."
        }
    }
    
    public var errorImage: UIImage
    {
        switch self {
        case .noConnection:
            return Constants.ERROR_NO_CONNECTION_IMAGE!
        case .notResourceFound:
            return Constants.ERROR_EMPTY_IMAGE!
        case .genericError:
            return Constants.ERROR_GENERIC_ERROR_IMAGE!
        case .unexpected:
            return Constants.ERROR_UNEXPECTED_ERROR_IMAGE!
        }
    }
}

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
