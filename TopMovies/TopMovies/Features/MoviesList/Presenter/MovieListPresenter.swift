//
//  MoviesListPresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Reachability

class MovieListPresenter: BasePresenter
{
    //MARK: - Variables
    var iView:MovieListViewController?
    var iInteractor:MovieListInteractor?
    var iRouter:MovieListRouter?
    
    var iTypeOfMovieList:TypeOfMovieList = .topRated
    
    var iLastScheduledSearch:Timer?
    var iCurrentSearchText:String = ""
    var iClearingSearchView:Bool = false
    
    var iMovieList:[Movie] = []
    {
        willSet(newMovieList)
        {
            self.iView?.iMovieList = newMovieList
            self.reloadCollectionViewOnMain()
        }
    }
    var iCurrentPage:Int = 0
    {
        willSet(newCurrentPage)
        {
            self.iView?.iCurrentPage = newCurrentPage
        }
    }
    var iTotalPages:Int = 0
    {
        willSet(newTotalPages)
        {
            self.iView?.iTotalPages = newTotalPages
        }
    }
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.iView?.setupUI()
        self.iView?.setupNavigationBar()
        self.iView?.showProgress()
        self.fetchNextMovieList()
    }
    
    func onViewWillLayoutSubviews()
    {
        Log.info(#function)
        self.iView?.collectionViewInvalidateLayout()
    }
    
    //MARK: - Fetch Methods
    func fetchNextMovieList(restartingData aRestartingData:Bool = false)
    {
        if self.iReachability.connection != .unavailable
        {
            self.doFetchNextMovieList(restartingData: aRestartingData)
        }
        else
        {
            self.iView?.dismisProgress()
            //No internet connection detected
            Log.warning("NO INTERNET CONNECTION DETECTED")
            self.iView?.showBackgroundError(forCustomError: CustomError.noConnection)
            
            //Wait for any connection online
            self.iReachability.whenReachable = { reachability in
                self.doFetchNextMovieList(restartingData: aRestartingData)
                self.stopNotifierReachability() //stop listening reachability
            }
            //Start reachability listener
            if self.starNotifierReachability() != nil
            {
                self.iView?.showBackgroundError(forCustomError: CustomError.genericError)
            }
        }
    }
    
    func doFetchNextMovieList(restartingData aRestartingData:Bool = false)
    {
        Log.info(#function)
        DispatchQueue.global().async {
            if aRestartingData
            {
                self.iMovieList = []
            }
            
            self.iInteractor?.fetchMovieList(forDataQuery: self.getMovieListDataQuery())
            self.setNavigationBarTitle()
        }
    }
    
    func getMovieListDataQuery() -> DataQuery
    {
        let dataQuery = Utils.getDataQuery(self.iCurrentSearchText.isEmpty ? .movie : .search,
                                           withPath: self.iCurrentSearchText.isEmpty ? self.iTypeOfMovieList.path : Constants.API_PATH_MOVIE)
        
        self.iCurrentPage += 1
        
        dataQuery.addPage(self.iCurrentPage)
        
        if !self.iCurrentSearchText.isEmpty
        {
            dataQuery.addQueryString(self.iCurrentSearchText)
        }
        
        self.Log.info("DataQuery: ")
        self.Log.info(dataQuery.toString())
        
        return dataQuery
    }
    
    private func setNavigationBarTitle()
    {
        DispatchQueue.main.async {
            self.iView?.iNavigationBarTitle = self.iCurrentSearchText.isEmpty ? self.iTypeOfMovieList.description : Constants.NAVIGATION_BAR_TITLE_MOVIESLITVC
            self.iView?.setupNavigationBar()
        }
    }
    
    //MARK: Fetch Complete
    func onFetchMovieListComplete(_ aResultType:ResultType,
                                  withError aCustomError:CustomError? = nil,
                                  withResults aResultsData:MovieList? = nil)
    {
        Log.info(#function)
        self.iView?.dismisProgress()
        
        guard aResultType == .succes,
              let movieList = aResultsData?.iResults,
              let currentPage = aResultsData?.iPage,
              let totalPages = aResultsData?.iTotalPages
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
        guard !movieList.isEmpty
        else
        {
            Log.warning("NO DATA RESULTS")
            DispatchQueue.main.async {
                self.iView?.showBackgroundError(forCustomError: CustomError.notResourceFound)
            }
            return
        }
    
        self.iTotalPages = totalPages
        Log.info("TotalPages: \(totalPages)")
        self.iCurrentPage = currentPage
        Log.info("currentPage: \(currentPage)")
        
        self.iMovieList.append(contentsOf: movieList)
        
        DispatchQueue.main.async {
            self.iView?.hideBackgroundError()
            if self.iClearingSearchView
            {
                self.iClearingSearchView = false
                self.iView?.collectionViewScrollToTop()
            }
        }
    }
    
    //MARK: - UISearchBarDelegate
    func onSearchBar(textDidChange aSearchText: String)
    {
        self.iLastScheduledSearch?.invalidate() //Cancel old request if any
        self.iLastScheduledSearch = Timer.scheduledTimer(timeInterval: aSearchText.isEmpty ? 0 : Constants.SEARCH_BAR_TIMER,
                                                   target: self,
                                                   selector: #selector(onStartSearching(_:)),
                                                   userInfo: aSearchText,
                                                   repeats: false)
    }
    
    func onSearchBarSearchButtonClicked()
    {
        self.iLastScheduledSearch?.invalidate() //Cancel old request if any
        self.iLastScheduledSearch = nil
        if let searchText = self.iView?.iSearchBar.text
        {
            self.aplySearch(searchText)
        }
    }
    
    //MARK: - UICollectionView
    private func reloadCollectionViewOnMain()
    {
        //Dispatch on main queue if not
        if Thread.isMainThread
        {
            self.iView?.reloadCollectionView()
        }
        else
        {
            DispatchQueue.main.async {
                self.iView?.reloadCollectionView()
            }
        }
    }

    //MARK: UICollectionViewDataSource
    func onCollectionView(willDisplayCellForItemAt aIndexPath: IndexPath)
    {
        guard self.iCurrentPage < self.iTotalPages,
              aIndexPath.row == self.iMovieList.count
        else { return }
        
        self.fetchNextMovieList()
    }

    //MARK: UICollectionViewDelegate
    func onCollectionView(didSelectItemAt aIndexPath: IndexPath)
    {
        guard aIndexPath.row < self.iMovieList.count
        else
        {
            Log.warning("Cant acces to iMovieList(\(self.iMovieList.count)) index: \(aIndexPath.row)")
            return
        }
        let movie = self.iMovieList[aIndexPath.row]
        
        let movieDetailModule = MovieDetailRoute.createModule()
        movieDetailModule.iMovie = movie
        
        self.iView?.navigationPush(viewController: movieDetailModule)
    }
    
    //MARK: - UISearchBar
    private func aplySearch(_ aSearchText:String)
    {
        self.setSearchingParameters(aSearchText)
        self.iView?.showProgress()
        self.fetchNextMovieList(restartingData: true)
    }
    
    func setSearchingParameters(_ aSearchText:String)
    {
        self.iCurrentSearchText = aSearchText
        self.iCurrentPage = 0
        self.iTotalPages = 0
        self.iClearingSearchView = aSearchText.isEmpty
    }
    
    //MARK: - Selectors
    @objc func onSettingsPressed()
    {
        Log.info(#function)
        let settingsVC = SettingsRouter.createModule()
        settingsVC.iSelectedTypeOfMovieList = self.iCurrentSearchText.isEmpty ? self.iTypeOfMovieList : .none
        settingsVC.modalPresentationStyle = .pageSheet
        settingsVC.iDelegate = self.iView
        self.iView?.navigationPresent(viewController: settingsVC)
    }
    
    @objc func onStartSearching(_ aTimer: Timer)
    {
        guard let searchText:String = aTimer.userInfo as? String
        else { return }
        
        self.aplySearch(searchText)
    }
    
    //MARK: - SettingsProtocol
    func onTypeOfMovieListChanged(_ aTypeOfMovieList: TypeOfMovieList)
    {
        Log.info(#function)
        self.iTypeOfMovieList = aTypeOfMovieList
        self.iView?.iSearchBar.text = ""
        self.setSearchingParameters("")
        self.iView?.showProgress()
        self.fetchNextMovieList(restartingData: true)
    }

}
