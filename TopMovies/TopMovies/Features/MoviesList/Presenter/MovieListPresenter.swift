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
            self.iInteractor.fetchMovieList(forPath: Constants.API_PATH_MOVIE_TOP_RATED,
                                            andPage: self.iView.iCurrentPage)
        }
    }
    func fetchPosterImage(withPath aPath:String, forCellIndexPath aIndexPath:IndexPath)
    {
        self.iInteractor.fetchPosterImage(forPosterPath: aPath,
                                          andCellIndexPath: aIndexPath)
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
    
    func onFetchPosterImage(forCellIndexPath aIndexPath:IndexPath, withPosterImage aPosterImage:UIImage? = nil)
    {
        let movie = self.iView.iMovieList[aIndexPath.row]
        movie.iPosterImageStatus = .complete
        if let posterImage = aPosterImage {
            movie.iPosterImage = posterImage
        }
        self.reloadCollectionViewOnMain(forIndexList: [aIndexPath])
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
    func onCollectionView(sizeForItemAt  aIndexPath: IndexPath)
    {
        if !self.iView.iCollectionCellsSizeSetted
        {
            self.setCollectionCellSize()
        }
    }
    func onCollectionView(cellForItemAt aIndexPath: IndexPath)
    {
        let movie = self.iView.iMovieList[aIndexPath.row]
        guard movie.iPosterImage == nil && movie.iPosterImageStatus == .none,
              let posterPath = movie.iPosterPath
        else
        {
            return
        }
        self.fetchPosterImage(withPath: posterPath, forCellIndexPath: aIndexPath)
    }
    func onCollectionView(willDisplayCellForItemAt aIndexPath: IndexPath)
    {
        if self.iView.iCurrentPage < self.iView.iTotalPages &&
            aIndexPath.row == self.iView.iMovieList.count
        {
            self.fetchNextMovieList()
        }
    }
    
    private func setCollectionCellSize()
    {
        Log.info(#function)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else
        {
            Log.warning("NO ACCESS TO WINDOW SCENE")
            return
        }
        
        let colums:CGFloat = windowScene.interfaceOrientation.isLandscape ?
        Constants.COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE :
        Constants.COLLECTION_VIEW_NUM_COMUNS_PORTRAIT
        
        let width = self.iView.iCollectionViewMovies.frame.width
        let itemWidth = width / colums
        self.iView.iCollectionCellSize = CGSize(width: itemWidth,
                                                height: itemWidth * Constants.COLLECTION_VIEW_CELL_ASPECT_RATIO)
        self.iView.iLoadingCollectionCellSize = CGSize(width: itemWidth,
                                                       height: itemWidth)
        self.iView.iCollectionCellsSizeSetted = true
    }
}
