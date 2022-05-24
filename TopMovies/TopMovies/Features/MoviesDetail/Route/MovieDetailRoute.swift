//
//  MovieDetailRoute.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

class MovieDetailRoute: BaseRouter
{
    static func createModule() -> MovieDetailViewController
    {
        let view = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        let presenter:MovieDetailPresenter = MovieDetailPresenter()
        let interactor:MovieDetailInteractor = MovieDetailInteractor()
        let router:MovieDetailRoute = MovieDetailRoute()
        
        view.iPresenter = presenter
        presenter.iView = view
        presenter.iRouter = router
        presenter.iInteractor = interactor
        interactor.iPresenter = presenter

        return view
    }
}
