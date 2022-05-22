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
    static let API_BASE_URL_IMAGES:String = "https://image.tmdb.org/t/p/original/"
    //MARK: Paths
    static let API_PATH_MOVIE_TOP_RATED:String = "movie/top_rated"
    static let API_PATH_MOVIE_DETAIL:String = "movie/:" //movie/:movie_id
    //MARK: QueryParameters
    static let QUERY_PARAMETER_API_KEY:String = "api_key"
    static let QUERY_PARAMETER_LANGUAGE:String = "language"
    static let QUERY_PARAMETER_PAGE:String = "page"
    
    //MARK: - Navigation Bar
    static let NAVIGATION_BAR_TITLE_FONT_SIZE = 22.0
    static let NAVIGATION_BAR_SETTINGS_ICON_IMAGE = UIImage(named: "setting")
    static let NAVIGATION_BAR_TITLE_MOVIESLITVC = "Top Movies"
    
    //MARK: - UICollectionView
    static let COLLECTION_VIEW_NUM_COMUNS_PORTRAIT = 2.0
    static let COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE = 6.0
    static let COLLECTION_VIEW_SPACING = 2.0
    static let COLLECTION_VIEW_CELL_ASPECT_RATIO = 1.66
    
    //MARK: - Colors
    static let APP_PRIMARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x0d253f)
    static let APP_SECONDARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x01b4e4)
    static let APP_TERTIARY_COLOR:UIColor = UIColor.colorWithHex(hex: 0x90cea1)
    
}
