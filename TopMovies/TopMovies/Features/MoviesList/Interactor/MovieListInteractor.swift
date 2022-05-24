//
//  MoviesListInteractor.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import ObjectMapper

class MovieListInteractor: BaseInteractor
{
    //MARK: - Variables
    var iPresenter:MovieListPresenter?
    
    //MARK: - Fetch API Methods
    func fetchMovieList(forPath aPath:String, andPage aPage:Int)
    {
        Log.info(#function)
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL)
        dataQuery.iPath = aPath
        dataQuery.iParameters[Constants.QUERY_PARAMETER_PAGE] = String(aPage)
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: dataQuery) { apiResponse in
            if apiResponse.iResultType == .succes
            {
                //Parsing Data to JSON
                guard let data = apiResponse.iDataResults,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                else
                {
                    //Unexpected no JSON serialization
                    self.Log.warning("Unexpected error parsing DATA to JSON")
                    self.iPresenter?.onFetchMovieList(.failure)
                    return
                }
                
                //Parsing JSON to Entities
                guard let results:MovieListResults = Mapper<MovieListResults>().map(JSON: json)
                else
                {
                    //Unexpected error parsing JSON to Entity
                    self.Log.warning("Unexpected error parsing JSON to Entity")
                    self.iPresenter?.onFetchMovieList(.failure)
                    return
                }
                self.iPresenter?.onFetchMovieList(.succes, withResults: results)
            }
            else //Response Fail
            {
                self.showResponseError(apiResponse.iError)
                self.iPresenter?.onFetchMovieList(.failure)
            }
        }
    }
    func fetchPosterImage(forPosterPath aPosterPath:String, andCellIndexPath aIndexPath:IndexPath)
    {
        //Log.info(#function) //To much logs...
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL_IMAGES)
        dataQuery.iPath = aPosterPath
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: dataQuery) { apiResponse in
            if apiResponse.iResultType == .succes
            {
                if let imageData = apiResponse.iDataResults
                {
                    let posterImage = UIImage(data: imageData)
                    self.iPresenter?.onFetchPosterImage(forCellIndexPath: aIndexPath,
                                                        withPosterImage: posterImage)
                }
                else
                {
                    self.Log.warning("NO DATA RESULTS FOR IMAGE: \(aPosterPath)")
                    self.iPresenter?.onFetchPosterImage(forCellIndexPath: aIndexPath)
                }
            }
            else
            {
                self.showResponseError(apiResponse.iError)
                self.iPresenter?.onFetchPosterImage(forCellIndexPath: aIndexPath)
            }
        }
    }
}
