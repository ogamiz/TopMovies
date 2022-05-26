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
    var iView:MovieDetailViewController!
    var iInteractor:MovieDetailInteractor!
    var iRouter:MovieDetailRoute!
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.fetchMovieDetail()
    }
    
    func setupUI()
    {
        self.iView.setupNavigationBar()
    }
    
    //MARK: - Fetch Methods
    func fetchMovieDetail()
    {
        Log.info(#function)
        self.iView.showProgress()
        
        guard let movieID = self.iView.iMovie?.iId
        else
        {
            Log.warning("No movie setted")
            return
        }
        
        DispatchQueue.global().async {
            self.iInteractor.fetchMovieDetail(forPath: Constants.API_PATH_MOVIE, withMovieID: movieID)
        }
    }
    
    //MARK: Fetch Complete
    func onFetchMovieDetail(_ aMovieDetail:MovieDetail? = nil, withResult aResultType:ResultType)
    {
        Log.info(#function)
        self.iView.dismisProgress()
        
        guard aResultType == .succes
        else
        {
            //TODO: show error icon
            return
        }
        
        guard let movieDetail = aMovieDetail
        else {
            //TODO: show empty icon
            return
        }
        
        self.iView.iMovie?.iMovieDetail = movieDetail
        if let crewList = movieDetail.iCredits?.iCrew
        {
            var shortCrew:[Crew] = []
            shortCrew.append(contentsOf: crewList.filter{$0.iJob == "Director"})
            shortCrew.append(contentsOf: crewList.filter{$0.iJob == "Producer"})
            shortCrew.append(contentsOf: crewList.filter{$0.iDepartment == "Writing"})
            self.iView.iCrewList = shortCrew
        }
        if let castList = movieDetail.iCredits?.iCast
        {
            self.iView.iCastList = castList
        }
        
        DispatchQueue.main.async {
            self.iView.setupMovieDetail()
            self.iView.reloadCollectionViews()
        }
    }
    
    //MARK: - UICollectionView
    //MARK: UICollectionViewDataSource
    func onCollectionView(cellForItemAt aIndexPath: IndexPath)
    {
        //Do somthing
    }
}
