//
//  CustomError.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit

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
            return NSLocalizedString("No internet connection detected", comment: "")
        case .notResourceFound:
            return NSLocalizedString("There are no results for the request made", comment: "")
        case .genericError:
            return NSLocalizedString("Something went wrong... Please try again", comment: "")
        case .unexpected:
            return NSLocalizedString("Unexpected error for the request made", comment: "")
        }
    }
    
    public var errorImage: UIImage
    {
        switch self {
        case .noConnection:
            return Constants.ERROR_NO_CONNECTION_IMAGE
        case .notResourceFound:
            return Constants.ERROR_EMPTY_IMAGE
        case .genericError:
            return Constants.ERROR_GENERIC_ERROR_IMAGE
        case .unexpected:
            return Constants.ERROR_UNEXPECTED_ERROR_IMAGE
        }
    }
}

