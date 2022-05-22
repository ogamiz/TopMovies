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
    func fetchTopRatedMovies(forPage aPage:Int)
    {
        Log.info(#function)
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL)
        dataQuery.iPath = Constants.API_PATH_MOVIE_TOP_RATED
        
        var parameters:[String:String] = self.getDefaultParameters()
        parameters[Constants.QUERY_PARAMETER_PAGE] = String(aPage)
        dataQuery.iParameters = parameters
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: dataQuery) { apiResponse in
            if apiResponse.iOperationType == .succes
            {
                //Parsing Data to JSON
                guard let data = apiResponse.iDataResults,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                else
                {
                    //Unexpected no JSON serialization
                    self.Log.warning("Unexpected error parsing DATA to JSON")
                    self.iPresenter?.topRatedMoviesFetchFail()
                    return
                }
                
                //Parsing JSON to Entities
                guard let results:MovieListResults = Mapper<MovieListResults>().map(JSON: json)
                else
                {
                    //Unexpected error parsing JSON to Entity
                    self.Log.warning("Unexpected error parsing JSON to Entity")
                    self.iPresenter?.topRatedMoviesFetchFail()
                    return
                }
                self.iPresenter?.topRatedMoviesFetchSuccess(withResults: results)
            }
            else //Response Fail
            {
                if let error = apiResponse.iError
                {
                    self.Log.error("Error from API:")
                    self.Log.error(error)
                }
                else
                {
                    self.Log.warning("API ERROR WITHOUT MESSAGE!")
                }
                self.iPresenter?.topRatedMoviesFetchFail()
            }
        }
    }
    func fetchPosterImage(withPosterPath aPosterPath:String, forCellIndexPath aIndexPath:IndexPath)
    {
        Log.info(#function)
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL_IMAGES)
        dataQuery.iPath = aPosterPath
        dataQuery.iParameters = self.getDefaultParameters()
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: dataQuery) { apiResponse in
            if apiResponse.iOperationType == .succes
            {
                
            }
            else
            {
                
            }
        }
    }
}
