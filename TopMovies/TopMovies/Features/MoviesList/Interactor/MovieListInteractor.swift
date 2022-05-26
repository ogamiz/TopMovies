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
    var iPresenter:MovieListPresenter!
    
    //MARK: - Fetch API Methods
    func fetchMovieList(forPath aPath:String, andPage aPage:Int)
    {
        Log.info(#function)
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL+Constants.API_PATH_MOVIE)
        dataQuery.iPath = aPath
        dataQuery.addLanguageParameters()
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
                    self.iPresenter.onFetchMovieList(.failure)
                    return
                }
                
                //Parsing JSON to Entities
                guard let results:MovieListResults = Mapper<MovieListResults>().map(JSON: json)
                else
                {
                    //Unexpected error parsing JSON to Entity
                    self.Log.warning("Unexpected error parsing JSON to Entity")
                    self.iPresenter.onFetchMovieList(.failure)
                    return
                }
                
                //Fetching Poster Images
                guard let movieList:[Movie] = results.iResults
                else
                {
                    //Unexpected error NO DATA RESULTS
                    self.Log.warning("Unexpected error NO DATA RESULTS")
                    self.iPresenter.onFetchMovieList(.failure)
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                for movie:Movie in movieList
                {
                    guard let posterPath = movie.iPosterPath
                    else { continue }
                    
                    dispatchGroup.enter()
                    //Search of the image resource
                    self.fetchImageResource(forPath: posterPath,
                                            withPathSize: Constants.API_BASE_URL_POSTER_SIZE) { image in
                        if let posterImage = image
                        {
                            movie.iPosterImage = posterImage
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .global()) {
                    self.iPresenter.onFetchMovieList(.succes, withResults: results)
                }
            }
            else //Response Fail
            {
                self.showResponseError(apiResponse.iError)
                self.iPresenter.onFetchMovieList(.failure)
            }
        }
    }
    
    func fetchImage(forMovieID aMovieID:Int, onCompletionBlock:@escaping (Images?) -> Void)
    {
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL + Constants.API_PATH_MOVIE)
        dataQuery.iPath = "\(aMovieID)"+"/"+Constants.API_PATH_IMAGES
        
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
                    self.iPresenter.onFetchMovieList(.failure)
                    return
                }
                
                //Parsing JSON to Entities
                guard let images:Images = Mapper<Images>().map(JSON: json)
                else
                {
                    //Unexpected error parsing JSON to Entity
                    self.Log.warning("Unexpected error parsing JSON to Entity")
                    onCompletionBlock(nil)
                    return
                }
                
                onCompletionBlock(images)
            }
            else
            {
                self.showResponseError(apiResponse.iError)
                onCompletionBlock(nil)
            }
        }
    }
}
