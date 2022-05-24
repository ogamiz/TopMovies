//
//  MoviesListRouter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

class MovieListRouter: BaseRouter
{
    static func createModule() -> MovieListViewController
    {
        let view = mainStoryboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        
        let presenter:MovieListPresenter = MovieListPresenter()
        let interactor:MovieListInteractor = MovieListInteractor()
        let router:MovieListRouter = MovieListRouter()
        
        view.iPresenter = presenter
        presenter.iView = view
        presenter.iRouter = router
        presenter.iInteractor = interactor
        interactor.iPresenter = presenter

        return view
    }
}
