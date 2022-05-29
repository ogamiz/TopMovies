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
    
    var iCrewList:[Crew] = []
    {
        willSet(newCrewList)
        {
            self.iView?.iCrewList = newCrewList
            self.reloadCollectionViewOnMain()
        }
    }
    var iCastList:[Cast] = []
    {
        willSet(newCastList)
        {
            self.iView?.iCastList = newCastList
            self.reloadCollectionViewOnMain()
        }
    }
    
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
    
    //MARK: - UICollectionViewCell
    private func reloadCollectionViewOnMain()
    {
        //Dispatch on main queue if not
        if Thread.isMainThread
        {
            self.iView?.reloadCollectionViews()
        }
        else
        {
            DispatchQueue.main.async {
                self.iView?.reloadCollectionViews()
            }
        }
    }
    
    private func reloadCastCollectionViewOnMain(forIndexPath aIndexPath:IndexPath)
    {
        //Dispatch on main queue if not
        if Thread.isMainThread
        {
            self.iView?.reloadCastCollectionView(forIndexPath: aIndexPath)
        }
        else
        {
            DispatchQueue.main.async {
                self.iView?.reloadCastCollectionView(forIndexPath: aIndexPath)
            }
        }
    }
    
    func onCollectionView(cellForItemAt aIndexPath: IndexPath)
    {
        guard let castList = self.iView?.iCastList,
              aIndexPath.row < castList.count
        else
        {
            return
        }
        
        let cast:Cast = castList[aIndexPath.row]
        
        guard cast.iProfileImageStatus == .none,
              let profilePath = cast.iProfilePath
        else
        {
            cast.iProfileImageStatus = .completed
            return
        }
        cast.iProfileImageStatus = .fetching
        self.iInteractor?.fetchProfileImage(withPath: profilePath, forCellIndexPath: aIndexPath)
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
    func onFetchProfileImageComplete(_ aResultType:ResultType,
                                     withImage aImage:UIImage? = nil,
                                     forCellIndexPath aIndexPath:IndexPath)
    {
        guard let castList = self.iView?.iCastList,
              aIndexPath.row < castList.count
        else
        {
            return
        }
        
        let cast:Cast = castList[aIndexPath.row]
        cast.iProfileImageStatus = .completed
        
        guard aResultType == .succes,
              let profileImage = aImage
        else
        {
            self.reloadCastCollectionViewOnMain(forIndexPath: aIndexPath)
            return
        }
        
        cast.iProfileImage = profileImage
        self.reloadCastCollectionViewOnMain(forIndexPath: aIndexPath)
    }
    
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
            self.iCrewList = shortCrew
        }
        if let castList = movieDetail.iCredits?.iCast
        {
            self.iCastList = castList
        }
        
        DispatchQueue.main.async {
            self.iView?.setupMovieDetail()
        }
    }
}
