//
//  Constants.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 21/5/22.
//

import Foundation
import UIKit
import ColorHex

class Constants
{
    //MARK: - Api
    //MARK: ApiKey
    static let API_KEY:String = "1cabc14aa36df93f88e9f0860baf3b19"
    //MARK: BaseURL
    static let API_BASE_URL:String = "https://api.themoviedb.org/3/"
    static let API_BASE_URL_IMAGES:String = "https://image.tmdb.org/t/p/"
    /*
     "backdrop_sizes": [
       "w300",
       "w780",
       "w1280",
       "original"
     ]
     */
    static let API_BASE_URL_BACKDROP_SIZE:String = "w780/"
    /*
     "poster_sizes": [
       "w92",
       "w154",
       "w185",
       "w342",
       "w500",
       "w780",
       "original"
     ]
     */
    static let API_BASE_URL_POSTER_SIZE:String = "w342/"
    /*
     "profile_sizes": [
       "w45",
       "w185",
       "h632",
       "original"
     ]
     */
    static let API_BASE_URL_PROFILE_SIZE:String = "w185/"
    
    //MARK: Paths
    static let API_PATH_MOVIE:String = "movie/"
    static let API_PATH_SEARCH:String = "search/"
    static let API_PATH_IMAGES:String = "images" //Images path dont have "/"
    static let API_PATH_TOP_RATED:String = "top_rated"
    static let API_PATH_POPULAR:String = "popular"
    static let API_PATH_UPCOMING:String = "upcoming"
    static let API_PATH_LASTET:String = "latest"
    static let API_PATH_NOW_PLAYING:String = "now_playing"
    //MARK: QueryStrings
    static let API_QUERY_APPEND_CREDITS:String = "credits"
    static let API_QUERY_APPEND_IMAGES:String = "images"
    
    //MARK: QueryParameters
    static let QUERY_PARAMETER_API_KEY:String = "api_key"
    static let QUERY_PARAMETER_LANGUAGE:String = "language"
    static let QUERY_PARAMETER_INCLUDE_LANGUAGES:String = "include_image_language"
    static let QUERY_PARAMETER_PAGE:String = "page"
    static let QUERY_PARAMETER_QUERY:String = "query"
    static let QUERY_PARAMETER_APPEND:String = "append_to_response"
    static let QUERY_PARAMETER_IMAGES:String = "images"
    static let QUERY_PARAMETER_CREDITS:String = "credits"
    
    //MARK: Results
    static let API_RESULTS_RELEASE_DATE_FORMAT = "yyyy-MM-dd"
    
    //MARK: - Segue
    static let SEGUE_IDENTIFIER_MOVIE_DETAIL_VC = "showMovieDetail"
    
    //MARK: - Navigation Bar
    static let NAVIGATION_BAR_TITLE_FONT_SIZE = 26.0
    static let NAVIGATION_BAR_SETTINGS_ICON_IMAGE = UIImage(named: "gear")
    static let NAVIGATION_BAR_SETTINGS_DEFAULT_ICON_IMAGE = UIImage(systemName: "gear")
    static let NAVIGATION_BAR_TITLE_MOVIESLITVC = "Top Movies"
    
    //MARK: - UISearchBar
    static let SEARCH_BAR_TIMER = 0.5
    
    //MARK: - UICollectionView
    static let COLLECTION_VIEW_NUM_COMUNS_PORTRAIT = 2.0
    static let COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE = 4.0
    static let COLLECTION_VIEW_SPACING = 2.0
    static let COLLECTION_VIEW_CELL_ASPECT_RATIO = 1.66
    static let COLLECTION_VIEW_CELL_DEFAULT_WIDTH = 128.0
    static let COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA = 0.8
    static let COLLECTION_VIEW_CELL_RATING_VIEW_BORDER = 3.0
    static let COLLECTION_VIEW_CELL_NO_IMAGE = "no_image"
    static let COLLECTION_VIEW_CELL_LOADING_INDICATOR_SCALE = 3.0
    static let COLLECTION_VIEW_CELL_IDENTIFIER = "MovieCollectionCell"
    static let COLLECTION_VIEW_CELL_LOADING_IDENTIFIER = "LoadingMovieCollectionCell"
    static let COLLECTION_VIEW_CELL_CREW_IDENTIFIER = "CrewCollectionViewCell"
    static let COLLECTION_VIEW_CELL_CAST_IDENTIFIER = "CastCollectionViewCell"
    
    //MARK: - MovieDetail
    static let OVERVIEW_CONSTRAIN_MULTIPLIER_1 = 0.15
    static let OVERVIEW_CONSTRAIN_MULTIPLIER_2 = 0.2
    static let OVERVIEW_CONSTRAIN_MULTIPLIER_3 = 0.25
    static let OVERVIEW_CONSTRAIN_MULTIPLIER_4 = 0.3
    static let OVERVIEW_CONSTRAIN_MULTIPLIER_5 = 0.35
    static let TITLE_GENERS_CONSTRAIN_MULTIPLIER_1 = 0.14
    static let TITLE_GENERS_CONSTRAIN_MULTIPLIER_2 = 0.18
    
    //MARK: - Colors
    static let APP_PRIMARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x0d253f)
    static let APP_SECONDARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x01b4e4)
    static let APP_TERTIARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x90cea1)
    
}
