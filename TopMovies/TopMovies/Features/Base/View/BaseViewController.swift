//
//  BaseViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log
import ProgressHUD

class BaseViewController: UIViewController {
    let Log = Logger()
    
    func setupNavigationBar()
    {
        if let navigationBar = self.navigationController?.navigationBar
        {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            if let backgroundImageColor = CAGradientLayer.primaryGradient(
                on: navigationBar,
                withInitialColor: Constants.APP_TERTIARY_COLOR,
                andFinishColor: Constants.APP_SECONDARY_COLOR)
            {
                appearance.backgroundColor = UIColor(patternImage: backgroundImageColor)
            }
            else
            {
                appearance.backgroundColor = Constants.APP_TERTIARY_COLOR
            }
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func showProgress()
    {
        if Thread.isMainThread
        {
            ProgressHUD.show()
        }
        else
        {
            DispatchQueue.main.async {
                ProgressHUD.show()
            }
        }
    }
    
    func dismisProgress()
    {
        if Thread.isMainThread
        {
            ProgressHUD.dismiss()
        }
        else
        {
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
        }
    }
}
