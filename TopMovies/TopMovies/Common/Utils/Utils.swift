//
//  Utils.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit
import ObjectMapper
import Log

open class Utils: NSObject
{
    //MARK: - JSON
    public static  func convertStringJSONToDictionary(_ aJsonString: String) -> [String:Any]?
    {
        guard let data = aJsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        else
        {
            Logger().warning("Unexpected error parsing DATA to JSON")
            return nil
        }
        return json
    }
    //MARK: - UIImages
    public static func resizeImage(_ aImage:UIImage, withSize aSize:CGSize) -> UIImage
    {
        let rect = CGRect(origin: .zero, size: aSize)
        UIGraphicsBeginImageContextWithOptions(aSize, false, 1.0)
        aImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? aImage
    }
    public static func getAppGradientColor(forView aView:UIView) -> UIColor
    {
        return self.getGradientColor(forView: aView,
                                     withInitialColor: Constants.APP_TERTIARY_COLOR,
                                     andLastColor: Constants.APP_SECONDARY_COLOR)
    }
    public static func getGradientColor(forView aView:UIView, withInitialColor aInitialColor:UIColor, andLastColor aLastColor:UIColor) -> UIColor
    {
        if let backgroundImageColor = CAGradientLayer.primaryGradient(
            on: aView,
            withInitialColor: aInitialColor,
            andFinishColor: aLastColor)
        {
            return UIColor(patternImage: backgroundImageColor)
        }
        else
        {
            return aInitialColor
        }
    }
    
    //MARK: - CollectionView
    public static func getNumberOfColumns() -> CGFloat
    {
        return self.Orientation.isLandscape ? Constants.COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE : Constants.COLLECTION_VIEW_NUM_COMUNS_PORTRAIT
    }
    
    public static func getFormattedDateByCountry(_ aDateString:String?, withFormat aFormat:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = aFormat
        
        guard let dateString = aDateString,
              let date = dateFormatter.date(from: dateString)
        else { return "" }
        
        let dateFormat = DateFormatter.dateFormat(fromTemplate: aFormat,
                                                  options: 0,
                                                  locale: Locale.current)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    //MARK: - Date
    public static func getFormattedTime(_ aTimeInt:Int?) -> String
    {
        guard let timeInt = aTimeInt
        else { return "" }

        if timeInt < 60
        {
            return "\(timeInt)m"
        }
        else
        {
            return "\(timeInt / 60)h\(timeInt % 60)m"
        }
    }
    
    //MARK: - DataQuery
    public static func getDataQuery(_ aType:DataQueryType,
                                    withPath aPath:String,
                                    forImageType aSize:QueryImageType = .original) -> DataQuery
    {   
        var baseURL:String = ""
        var path:String = ""
        switch aType
        {
        case .movie:
            baseURL = Constants.API_BASE_URL
            path = Constants.API_PATH_MOVIE
            break
        case .search:
            baseURL = Constants.API_BASE_URL
            path = Constants.API_PATH_SEARCH
            break
        case .image:
            baseURL = Constants.API_BASE_URL_IMAGES + self.getSizeForImageType(aSize)
            break
        }
        
        path += aPath
        let dataQuery = DataQuery(baseURL: baseURL, path: path)
        if aType == .movie || aType == .search
        {
            dataQuery.addLanguage()
            dataQuery.addRegion()
        }
        
        return dataQuery
    }
    
    public static func getSizeForImageType(_ aType:QueryImageType) -> String
    {
        switch aType
        {
        case .profile:
            return Constants.API_BASE_URL_PROFILE_SIZE
        case .backdrop:
            return Constants.API_BASE_URL_BACKDROP_SIZE
        case .poster:
            return Constants.API_BASE_URL_POSTER_SIZE
        case .original:
            return Constants.API_BASE_URL_DEFAULT_SIZE
        }
    }
    
    //MARK: - Strunct Orientation
    public struct Orientation
    {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool
        {
            get { return UIWindow.isLandscape }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool
        {
            get { return UIWindow.isPortrait }
        }
    }
}
