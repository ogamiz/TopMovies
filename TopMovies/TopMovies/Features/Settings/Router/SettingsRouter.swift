//
//  SettingsRouter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit

class SettingsRouter: BaseRouter
{
    static func createModule() -> SettingsViewController
    {
        let view = mainStoryboard.instantiateViewController(withIdentifier: SettingsViewController.identifier) as! SettingsViewController
        
        let presenter:SettingsPresenter = SettingsPresenter()
        let router:SettingsRouter = SettingsRouter()
        
        view.iPresenter = presenter
        presenter.iView = view
        presenter.iRouter = router

        return view
    }

}
