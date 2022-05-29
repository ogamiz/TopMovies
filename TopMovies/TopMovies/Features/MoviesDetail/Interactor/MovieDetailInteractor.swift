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
    //MARK: MovieDetail
    func fetchMovieDetail(withDdataQuery aDataQuery:DataQuery)
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
                        self.iPresenter.onFetchMovieDetailComplete(.failure, withError: CustomError.noConnection)
                        return
                    }
                }
                self.iPresenter.onFetchMovieDetailComplete(.failure, withError: CustomError.genericError)
                return
            }
            //Parsing Data to JSON
            guard let data = apiResponse.iDataResults,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            else
            {
                self.Log.warning("Unexpected error parsing DATA to JSON")
                self.iPresenter.onFetchMovieDetailComplete(.failure, withError: CustomError.genericError)
                return
            }
            
            //Parsing JSON to Entities
            guard let movieDetail:MovieDetail = Mapper<MovieDetail>().map(JSON: json)
            else
            {
                self.Log.warning("Unexpected error parsing JSON to \(String(describing: MovieDetail.self))")
                self.iPresenter.onFetchMovieDetailComplete(.failure, withError: CustomError.genericError)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            //Get Backdrop Image
            if let backdropPath = movieDetail.iBackdropPath
            {
                dispatchGroup.enter()
                self.fetchImageResource(forPath: backdropPath,
                                        forImageType: .backdrop) { image in
                    if let backdropImage = image
                    {
                        movieDetail.iBackdropImage = backdropImage
                    }
                    dispatchGroup.leave()
                }
            }
            
            //Get Cast Images
            if let castList = movieDetail.iCredits?.iCast
            {
                for cast in castList
                {
                    if let profilePath = cast.iProfilePath
                    {
                        dispatchGroup.enter()
                        self.fetchImageResource(forPath: profilePath,
                                                forImageType: .profile) { image in
                            if let profileImage = image
                            {
                                cast.iProfileImage = profileImage
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            //Return data
            dispatchGroup.notify(queue: .global())
            {
                self.iPresenter.onFetchMovieDetailComplete(.succes, withResult: movieDetail)
            }
        }
    }
    
    func fetchProfileImage(withPath aPath:String, forCellIndexPath aCellIndexPath:IndexPath)
    {
        self.fetchImageResource(forPath: aPath,
                                forImageType: .profile) { image in
            if let profileImage = image
            {
                self.iPresenter.onFetchProfileImageComplete(.succes, withImage: profileImage, forCellIndexPath: aCellIndexPath)
            }
            self.iPresenter.onFetchProfileImageComplete(.failure, forCellIndexPath: aCellIndexPath)
        }
    }
}
