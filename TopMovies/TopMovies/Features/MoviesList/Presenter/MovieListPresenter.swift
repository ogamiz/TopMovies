//
//  MoviesListPresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

class MovieListPresenter: BasePresenter
{
    //MARK: - Variables
    var iView:MovieListViewController!
    var iInteractor:MovieListInteractor!
    var iRouter:MovieListRouter!
    
    var iCurrentPrePath:String = Constants.API_PATH_MOVIE
    var iCurrentPostPath:String = Constants.API_PATH_TOP_RATED
    var iSelectedFilterPostPath:String = Constants.API_PATH_TOP_RATED

    var iLastScheduledSearch:Timer?
    var iCurrentSearchText:String = ""
    var iClearingSearchView:Bool = false
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.iView.setupNavigationBar()
        self.setupUI()
        self.iView.showProgress()
        self.fetchNextMovieList()
    }
    
    func onViewWillLayoutSubviews()
    {
        Log.info(#function)
        self.iView.collectionViewInvalidateLayout()
    }
    
    func setupUI()
    {
        Log.info(#function)
        self.iView.setupUI()
    }
    
    //MARK: - Fetch Methods
    func fetchNextMovieList(restartingData aRestartingData:Bool = false)
    {
        Log.info(#function)
        DispatchQueue.global().async {
            if aRestartingData
            {
                self.iView.iMovieList = []
            }
            self.iView.iCurrentPage += 1
            let path = self.iCurrentPrePath + self.iCurrentPostPath
            
            if (!self.iCurrentSearchText.isEmpty && self.iView.iCurrentPage == 1) || self.iClearingSearchView
            {
                self.iView.showProgress()
            }
            
            self.iInteractor.fetchMovieList(forPath: path,
                                            andPage: self.iView.iCurrentPage,
                                            withQueryString: self.iCurrentSearchText.isEmpty ? nil : self.iCurrentSearchText)
        }
    }
    
    //MARK: Fetch Complete
    func onFetchMovieList(_ aResultType:ResultType, withResults aResultsData:MovieListResults? = nil)
    {
        Log.info(#function)
        guard aResultType == .succes,
        let movieList = aResultsData?.iResults,
        let currentPage = aResultsData?.iPage,
        let totalPages = aResultsData?.iTotalPages
        else
        {
            //TODO: show error icon
            self.iView.dismisProgress()
            Log.warning("Result: FAIL")
            return
        }
        
        Log.info("Result: SUCESS")
        
        guard !movieList.isEmpty
        else {
            //TODO: show empty icon
            Log.warning("NO DATA RESULTS")
            return
        }
    
        self.iView.iTotalPages = totalPages
        Log.info("TotalPages: \(totalPages)")
        self.iView.iCurrentPage = currentPage
        Log.info("currentPage: \(currentPage)")
        
        self.iView.iMovieList.append(contentsOf: movieList)
        
        DispatchQueue.main.async {
            self.iView.dismisProgress()
            self.reloadCollectionViewOnMain()
            if self.iClearingSearchView
            {
                self.iClearingSearchView = false
                self.iView.collectionViewScrollToTop()
            }
        }
    }
    
    //MARK: - UISearchBarDelegate
    func onSearchBar(textDidChange searchText: String)
    {
        self.iLastScheduledSearch?.invalidate() //Cancel old request if any
        self.iLastScheduledSearch = Timer.scheduledTimer(timeInterval: 0.5, //Seconds
                                                   target: self,
                                                   selector: #selector(onStartSearching(_:)),
                                                   userInfo: searchText,
                                                   repeats: false)
    }
    
    func onSearchBarSearchButtonClicked()
    {
        self.iLastScheduledSearch?.invalidate() //Cancel old request if any
        self.iLastScheduledSearch = nil
    }
    
    //MARK: - UICollectionView
    private func reloadCollectionViewOnMain()
    {
        //Dispatch on main queue if not
        if Thread.isMainThread
        {
            self.iView.reloadCollectionView()
        }
        else
        {
            DispatchQueue.main.async {
                self.iView.reloadCollectionView()
            }
        }
    }
    private func reloadCollectionViewOnMain(forIndexList aIndexPathList:[IndexPath])
    {
        //Dispatch on main queue if not
        if Thread.isMainThread
        {
            self.iView.reloadCollectionView(forIndexList: aIndexPathList)
        }
        else
        {
            DispatchQueue.main.async {
                self.iView.reloadCollectionView(forIndexList: aIndexPathList)
            }
        }
    }
    
    //MARK: UICollectionViewDataSource
    func onCollectionView(cellForItemAt aIndexPath: IndexPath)
    {
        //Do somthing
    }
    func onCollectionView(willDisplayCellForItemAt aIndexPath: IndexPath)
    {
        if self.iView.iCurrentPage < self.iView.iTotalPages &&
            aIndexPath.row == self.iView.iMovieList.count
        {
            self.fetchNextMovieList()
        }
    }

    //MARK: UICollectionViewDelegate
    func onCollectionView(didSelectItemAt aIndexPath: IndexPath)
    {
        guard aIndexPath.row < self.iView.iMovieList.count
        else
        {
            Log.warning("Cant acces to iMovieList(\(self.iView.iMovieList.count)) index: \(aIndexPath.row)")
            return
        }
        let movie = self.iView.iMovieList[aIndexPath.row]
        
        let movieDetailModule = MovieDetailRoute.createModule()
        movieDetailModule.iMovie = movie
        
        self.iView.navigationPush(viewController: movieDetailModule)
    }
    
    //MARK: - SELECTORS
    @objc func onSettingsPressed()
    {
        Log.info(#function)
    }
    
    @objc func onStartSearching(_ aTimer: Timer)
    {
        guard let searchText:String = aTimer.userInfo as? String
        else { return }
        
        self.iCurrentSearchText = searchText
        self.iView.iCurrentPage = 0
        
        if searchText.isEmpty
        {
            self.iCurrentPrePath = Constants.API_PATH_MOVIE
            self.iCurrentPostPath = self.iSelectedFilterPostPath
            self.iClearingSearchView = true
        }
        else
        {
            self.iCurrentPrePath = Constants.API_PATH_SEARCH
            self.iCurrentPostPath = Constants.API_PATH_MOVIE
        }
        
        self.fetchNextMovieList(restartingData: true)
    }
  
}
