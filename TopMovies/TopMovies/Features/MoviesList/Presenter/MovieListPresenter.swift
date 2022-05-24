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
    var iView:MovieListViewController?
    var iInteractor:MovieListInteractor?
    var iRouter:MovieListRouter?
    
    var iCurrentPage:Int = 1
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.iView?.setupNavigationBar()
        self.setupUI()
        
        DispatchQueue.global().async {
            self.iView?.showProgress()
            self.iInteractor?.fetchMovieList(forPath: Constants.API_PATH_MOVIE_TOP_RATED,
                                             andPage: self.iCurrentPage)
        }
    }
    
    func setupUI()
    {
        self.iView?.setupUI()
    }
    
    //MARK: - Fetch Methods
    func fetchPosterImage(withPath aPath:String, forCellIndexPath aIndexPath:IndexPath)
    {
        DispatchQueue.global().async {
            self.iInteractor?.fetchPosterImage(forPosterPath: aPath, andCellIndexPath: aIndexPath)
        }
    }
    
    //MARK: - UICollectionView
    func onCollectionViewSizeForItemAt()
    {
        if self.iView?.iCollectionCellSize == nil
        {
            self.setCollectionCellSize()
        }
    }
    
    private func setCollectionCellSize()
    {
        var colums:CGFloat
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        {
            if windowScene.interfaceOrientation.isLandscape
            {
                colums = Constants.COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE
            }
            else
            {
                colums = Constants.COLLECTION_VIEW_NUM_COMUNS_PORTRAIT
            }
            
            if let width = self.iView?.iCollectionViewMovies.frame.width
            {
                let itemWidth = width / colums
                let itemSize = CGSize(width: itemWidth, height: itemWidth * Constants.COLLECTION_VIEW_CELL_ASPECT_RATIO)
                self.iView?.iCollectionCellSize = itemSize
            }
            else
            {
                self.iView?.iCollectionCellSize = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
            }
        }
        else
        {
            self.iView?.iCollectionCellSize = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
        }
    }
    
    //MARK: Fetch Complete
    func onFetchMovieList(_ aResultType:ResultType, withResults aResultsData:MovieListResults? = nil)
    {
        Log.info(#function)
        if aResultType == .succes
        {
            if let movieList = aResultsData?.iResults
            {
                //TODO: manage pages and total results
                self.iView?.iMovieList.append(contentsOf: movieList)
                self.iView?.reloadCollectionView()
            }
            else
            {
                //TODO: show empty icon
            }

        }
        else
        {
            //TODO: show error icon
        }
        
        self.iView?.dismisProgress()
    }
    
    func onFetchPosterImage(forCellIndexPath aIndexPath:IndexPath, withPosterImage aPosterImage:UIImage? = nil)
    {
//        Log.info(#function) //To much logs...
        guard let movie = self.iView?.iMovieList[aIndexPath.row]
        else
        {
            Log.warning("No item movie for index \(aIndexPath.row)")
            return
        }
        DispatchQueue.main.async {
            if let posterImage = aPosterImage
            {
                var size = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
                if let sizeTmp = self.iView?.iCollectionCellSize
                {
                    size = sizeTmp
                }
                movie.iPosterImage = Tools.resizeImage(posterImage, withSize: size)
            }
            
            movie.iPosterImageStatus = .complete
            self.iView?.reloadCollectionView(aIndexPath)
        }
    }
}
