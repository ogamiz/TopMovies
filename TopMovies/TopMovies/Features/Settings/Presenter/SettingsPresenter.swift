//
//  SettingsPresenter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit

class SettingsPresenter: BasePresenter
{
    //MARK: - Variables
    var iView:SettingsViewController?
    var iRouter:SettingsRouter?
    
    //MARK: - Lifecyle
    func onViewDidLoad()
    {
        Log.info(#function)
        self.setupUI()
    }
    
    private func setupUI()
    {
        self.iView?.setupLabels()
        self.iView?.setupSwitches()
    }
    
    //MARK: - IBActions
    func onButtonClosePressed()
    {
        self.iView?.dismiss(animated: true)
    }
    func onSwitchValueChange(_ aSender: UISwitch)
    {
        Log.info(#function)
        var selectedType:TypeOfMovieList = .topRated

        switch aSender
        {
        case self.iView?.iSwitchTopRated:
            selectedType = .topRated
        case self.iView?.iSwitchPopular:
            selectedType = .popular
        case self.iView?.iSwitchUpcoming:
            selectedType = .upcoming
        case self.iView?.iSwitchNowPlaying:
            selectedType = .nowPlaying
        default:
            selectedType = .topRated
        }
        
        if selectedType == self.iView?.iSelectedTypeOfMovieList
        {
            self.iView?.setSwitchSelectedON()
        }
        else
        {
            self.iView?.setSwitchNotSelectedOff(selectedType)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) //Time to animate switch change
            {
                self.iView?.dismiss(animated: true, completion: {
                    self.iView?.sendDelegateTypeOfMovieList(selectedType)
                })
            }
        }
    }
}
