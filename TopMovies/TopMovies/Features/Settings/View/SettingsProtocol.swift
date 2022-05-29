//
//  SettingsProtocol.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import Foundation

public enum TypeOfMovieList
{
    case topRated
    case popular
    case upcoming
    case nowPlaying
    case none
    
    public var path: String
    {
        switch self {
        case .topRated:
            return Constants.API_PATH_TOP_RATED
        case .popular:
            return Constants.API_PATH_POPULAR
        case .upcoming:
            return Constants.API_PATH_UPCOMING
        case .nowPlaying:
            return Constants.API_PATH_NOW_PLAYING
        case .none:
            return Constants.API_PATH_TOP_RATED
        }
    }
    public var description: String
    {
        switch self {
        case .topRated:
            return NSLocalizedString("Top rated", comment: "")
        case .popular:
            return NSLocalizedString("More popular", comment: "")
        case .upcoming:
            return NSLocalizedString("Upcoming releases", comment: "")
        case .nowPlaying:
            return NSLocalizedString("Now in theaters", comment: "")
        case .none:
            return Constants.NAVIGATION_BAR_TITLE_MOVIESLITVC
        }
    }
}

protocol SettingsProtocol
{
    func onTypeOfMovieListChanged(_ aTypeOfMovieList:TypeOfMovieList)
}
