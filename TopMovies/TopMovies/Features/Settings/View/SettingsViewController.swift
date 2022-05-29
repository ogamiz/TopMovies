//
//  SettingsViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit

class SettingsViewController: BaseViewController
{
    
    //MARK: - Properties
    @IBOutlet weak var iSwitchTopRated: UISwitch!
    @IBOutlet weak var iLabelTopRated: UILabel!
    
    @IBOutlet weak var iSwitchPopular: UISwitch!
    @IBOutlet weak var iLabelPopular: UILabel!
    
    @IBOutlet weak var iSwitchUpcoming: UISwitch!
    @IBOutlet weak var iLabelUpcoming: UILabel!
    
    @IBOutlet weak var iSwitchNowPlaying: UISwitch!
    @IBOutlet weak var iLabelNowPlaying: UILabel!
    
    //MARK: - Variables
    var iPresenter:SettingsPresenter?
    
    var iDelegate:SettingsProtocol? = nil
    
    var iSelectedTypeOfMovieList:TypeOfMovieList = .topRated
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iPresenter?.onViewDidLoad()
    }
    
    //MARK: - Interface Methods
    func setupLabels()
    {
        self.iLabelTopRated.text = NSLocalizedString("Top rated", comment: "")
        self.iLabelPopular.text = NSLocalizedString("More popular", comment: "")
        self.iLabelUpcoming.text = NSLocalizedString("Upcoming releases", comment: "")
        self.iLabelNowPlaying.text = NSLocalizedString("Now in theaters", comment: "")
        
    }
    func setupSwitches()
    {
        self.iSwitchTopRated.onTintColor = Constants.APP_TERTIARY_COLOR
        self.iSwitchPopular.onTintColor = Constants.APP_TERTIARY_COLOR
        self.iSwitchUpcoming.onTintColor = Constants.APP_TERTIARY_COLOR
        self.iSwitchNowPlaying.onTintColor = Constants.APP_TERTIARY_COLOR
        
        self.setSwitchSelectedON()
    }
    
    func setSwitchSelectedON()
    {
        switch self.iSelectedTypeOfMovieList
        {
        case .topRated:
            self.iSwitchTopRated.setOn(true, animated: true)
        case .popular:
            self.iSwitchPopular.setOn(true, animated: true)
        case .upcoming:
            self.iSwitchUpcoming.setOn(true, animated: true)
        case .nowPlaying:
            self.iSwitchNowPlaying.setOn(true, animated: true)
        case .none:
            self.iSwitchTopRated.setOn(false, animated: true)
            self.iSwitchPopular.setOn(false, animated: true)
            self.iSwitchUpcoming.setOn(false, animated: true)
            self.iSwitchNowPlaying.setOn(false, animated: true)
        }
    }
    
    func setSwitchNotSelectedOff(_ aSelectedTypeOfList:TypeOfMovieList)
    {
        switch aSelectedTypeOfList {
        case .topRated:
            self.iSwitchPopular.setOn(false, animated: true)
            self.iSwitchUpcoming.setOn(false, animated: true)
            self.iSwitchNowPlaying.setOn(false, animated: true)
        case .popular:
            self.iSwitchTopRated.setOn(false, animated: true)
            self.iSwitchUpcoming.setOn(false, animated: true)
            self.iSwitchNowPlaying.setOn(false, animated: true)
        case .upcoming:
            self.iSwitchTopRated.setOn(false, animated: true)
            self.iSwitchPopular.setOn(false, animated: true)
            self.iSwitchNowPlaying.setOn(false, animated: true)
        case .nowPlaying:
            self.iSwitchTopRated.setOn(false, animated: true)
            self.iSwitchPopular.setOn(false, animated: true)
            self.iSwitchUpcoming.setOn(false, animated: true)
        case .none:
            self.iSwitchTopRated.setOn(false, animated: true)
            self.iSwitchPopular.setOn(false, animated: true)
            self.iSwitchUpcoming.setOn(false, animated: true)
            self.iSwitchNowPlaying.setOn(false, animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func onButtonClosePressed(_ sender: Any)
    {
        self.iPresenter?.onButtonClosePressed()
    }
    @IBAction func onSwitchValueChange(_ sender: UISwitch)
    {
        self.iPresenter?.onSwitchValueChange(sender)
    }
    
    func sendDelegateTypeOfMovieList(_ aTypeOfMovieList:TypeOfMovieList)
    {
        if let delegate = self.iDelegate {
            delegate.onTypeOfMovieListChanged(aTypeOfMovieList)
        }
    }
}


