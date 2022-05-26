//
//  MovieDetailInteractor.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit
import ObjectMapper

class MovieDetailInteractor:
    BaseInteractor
{
    //MARK: - Variables
    var iPresenter:MovieDetailPresenter!
    
    //MARK: - Fetch API Methods
    func fetchMovieDetail(forMovieID aID:Int)
    {
        Log.info(#function)
        let dataQuery = DataQuery(baseURL: Constants.API_BASE_URL + Constants.API_PATH_MOVIE)
        dataQuery.iPath = "\(aID)"
        dataQuery.addLanguageParameters()
        dataQuery.iParameters[Constants.QUERY_PARAMETER_APPEND] = Constants.API_QUERY_APPEND_CREDITS+","+Constants.API_QUERY_APPEND_IMAGES
        
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
                    self.iPresenter.onFetchMovieDetail(withResult: .failure)
                    return
                }
                
                //Parsing JSON to Entities
                guard let movieDetail:MovieDetail = Mapper<MovieDetail>().map(JSON: json)
                else
                {
                    //Unexpected error parsing JSON to Entity
                    self.Log.warning("Unexpected error parsing JSON to Entity")
                    self.iPresenter.onFetchMovieDetail(withResult: .failure)
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                
                dispatchGroup.enter()
                //Backdrop Image
                if let backdropPath = movieDetail.iBackdropPath
                {
                    //Search of the image resource
                    self.fetchImageResource(forPath: backdropPath,
                                            withPathSize: Constants.API_BASE_URL_BACKDROP_SIZE) { image in
                        if let backdropImage = image
                        {
                            movieDetail.iBackdropImage = backdropImage
                        }
                        dispatchGroup.leave()
                    }
                }
                else
                {
                    dispatchGroup.leave()
                }
                
                //Cast Images
                if let castList = movieDetail.iCredits?.iCast
                {
                    for cast in castList
                    {
                        if let profilePath = cast.iProfilePath
                        {
                            dispatchGroup.enter()
                            self.fetchImageResource(forPath: profilePath,
                                                    withPathSize: Constants.API_BASE_URL_PROFILE_SIZE) { image in
                                if let profileImage = image
                                {
                                    cast.iProfileImage = profileImage
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                                
                dispatchGroup.notify(queue: .global())
                {
                    self.iPresenter.onFetchMovieDetail(movieDetail, withResult: .succes)
                }
            }
            else //Response Fail
            {
                self.showResponseError(apiResponse.iError)
                
            }
        }
    }
}
