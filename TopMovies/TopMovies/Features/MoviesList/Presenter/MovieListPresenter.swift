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
    
    var iSelectedIndexPath:IndexPath?
    
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
    func fetchNextMovieList()
    {
        Log.info(#function)
        DispatchQueue.global().async {
            self.iView.iCurrentPage += 1
            self.iInteractor.fetchMovieList(forPath: Constants.API_PATH_TOP_RATED,
                                            andPage: self.iView.iCurrentPage)
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
            return
        }
        
        guard !movieList.isEmpty
        else {
            //TODO: show empty icon
            return
        }
        
        self.iView.iTotalPages = totalPages
        self.iView.iCurrentPage = currentPage
        self.iView.iMovieList.append(contentsOf: movieList)
        DispatchQueue.main.async {
            self.iView.dismisProgress()
            self.reloadCollectionViewOnMain()
        }
    }
    
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
    
    //MARK: - UICollectionView
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
  
}
