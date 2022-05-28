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
    //MARK: MovieList
    func fetchMovieList(forDataQuery aDataQuery:DataQuery)
    {
        Log.info(#function)
        
        self.iApiDataStore.fetchGetRequest(withDataQuery: aDataQuery) { apiResponse in
            guard apiResponse.iResultType == .succes
            else //Response Fail
            {
                self.Log.warning("FAIL RESPONSE")
                self.showResponseError(apiResponse.iError)
                if let nsError = apiResponse.iError as? NSError
                {
                    if nsError.code == Constants.API_RESPONSE_ERROR_NO_CONNECTION
                    {
                        self.iPresenter?.onFetchMovieListComplete(.failure,
                                                                 withError: CustomError.noConnection)
                        return
                    }
                }
                self.iPresenter?.onFetchMovieListComplete(.failure,
                                                         withError: CustomError.genericError)
                return
            }
            
            //Parsing Data to JSON
            guard let data = apiResponse.iDataResults,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            else
            {
                self.Log.warning("Unexpected error parsing DATA to JSON")
                self.iPresenter?.onFetchMovieListComplete(.failure,
                                                         withError: CustomError.genericError)
                return
            }
            
            //Parsing JSON to Entities
            guard let results:MovieList = Mapper<MovieList>().map(JSON: json)
            else
            {
                self.Log.warning("Unexpected error parsing JSON to \(String(describing: MovieList.self))")
                self.iPresenter?.onFetchMovieListComplete(.failure,
                                                         withError: CustomError.genericError)
                return
            }
            
            //No empty results
            guard let movieList:[Movie] = results.iResults
            else
            {
                self.Log.warning("Unexpected error NO DATA RESULTS")
                self.iPresenter?.onFetchMovieListComplete(.failure, withError: CustomError.notResourceFound)
                return
            }

            
            let dispatchGroup = DispatchGroup()
            for movie:Movie in movieList
            {
                guard let posterPath = movie.iPosterPath
                else { continue }
                
                dispatchGroup.enter()
                //Get Poster Image
                self.fetchImageResource(forPath: posterPath,
                                        forImageType: .poster) { image in
                    if let posterImage = image
                    {
                        movie.iPosterImage = posterImage
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .global())
            {
                self.iPresenter?.onFetchMovieListComplete(.succes, withResults: results)
            }
        }
    }
}
