//
//  MovieDetailPresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

class MovieDetailPresenter:
    BasePresenter
{
    //MARK: - Variables
    var iView:MovieDetailViewController?
    var iInteractor:MovieDetailInteractor?
    var iRouter:MovieDetailRoute?
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.iView?.setupNavigationBar()
        self.fetchMovieDetail()
    }
    
    func setupUI()
    {
        self.iView?.setupNavigationBar()
    }
    
    //MARK: - Fetch Methods
    func fetchMovieDetail()
    {
        Log.info(#function)
        self.iView?.showProgress()
        
        guard let movieID = self.iView?.iMovie?.iId
        else
        {
            self.iView?.dismisProgress()
            Log.warning("NO MOVIE SETTED")
            self.iView?.showBackgroundError(forCustomError: CustomError.genericError)
            return
        }
        
        DispatchQueue.global().async {
            let dataQuery = self.getMovieDetailDataQuery(movieID)
            self.iInteractor?.fetchMovieDetail(withDdataQuery: dataQuery)
        }
    }
    
    func getMovieDetailDataQuery(_ aMovieID:Int) -> DataQuery
    {
        let dataQuery:DataQuery = Utils.getDataQuery(.movie, withPath: "\(aMovieID)")
        
        dataQuery.addQueryAppend(Constants.API_QUERY_APPEND_CREDITS)
        
        Log.info("DataQuery: ")
        Log.info(dataQuery.toString())
        return dataQuery
    }
    
    //MARK: Fetch Complete
    func onFetchMovieDetailComplete(_ aResultType:ResultType,
                                    withError aCustomError:CustomError? = nil,
                                    withResult aMovieDetail:MovieDetail? = nil)
    {
        Log.info(#function)
        self.iView?.dismisProgress()
        
        guard aResultType == .succes
        else
        {
            Log.warning("Result: FAIL")
            //show error
            DispatchQueue.main.async {
                if let error = aCustomError
                {
                    self.iView?.showBackgroundError(forCustomError: error)
                }
                self.iView?.showBackgroundError(forCustomError: CustomError.unexpected)
            }
            return
        }
        
        Log.info("Result: SUCESS")
        
        guard let movieDetail = aMovieDetail
        else {
            self.iView?.showBackgroundError(forCustomError: CustomError.notResourceFound)
            return
        }
        
        self.iView?.iMovie?.iMovieDetail = movieDetail
        if let crewList = movieDetail.iCredits?.iCrew
        {
            var shortCrew:[Crew] = []
            shortCrew.append(contentsOf: crewList.filter{$0.iJob == "Director"})
            shortCrew.append(contentsOf: crewList.filter{$0.iJob == "Producer"})
            shortCrew.append(contentsOf: crewList.filter{$0.iDepartment == "Writing"})
            self.iView?.iCrewList = shortCrew
        }
        if let castList = movieDetail.iCredits?.iCast
        {
            self.iView?.iCastList = castList
        }
        
        DispatchQueue.main.async {
            self.iView?.setupMovieDetail()
            self.iView?.reloadCollectionViews()
        }
    }
}
