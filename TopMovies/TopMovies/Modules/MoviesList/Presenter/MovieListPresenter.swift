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
    
    //MARK: - Lifecycle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.iView?.setupNavigationBar()
        self.iView?.setupUI()
        
        DispatchQueue.global().async {
            self.iView?.showProgress()
            self.iInteractor?.fetchTopRatedMovies(forPage: 1)
        }
    }
    
    func fetchPosterImage(withPath aPath:String, forCellIndexPath aIndexPath:IndexPath)
    {
        self.iInteractor?.fetchPosterImage(withPosterPath: aPath, forCellIndexPath: aIndexPath)
    }
    
    func topRatedMoviesFetchSuccess(withResults aResults:MovieListResults)
    {
        Log.info(#function)
        if let movieList = aResults.iResults
        {
            self.iView?.iMovieList.append(contentsOf: movieList)
            self.iView?.reloadCollectionView()
        }
        else
        {
            //TODO: show empty icon
        }
        self.iView?.dismisProgress()
    }
    
    func topRatedMoviesFetchFail()
    {
        Log.info(#function)
        //TODO: show error icon
        self.iView?.dismisProgress()
    }
}
