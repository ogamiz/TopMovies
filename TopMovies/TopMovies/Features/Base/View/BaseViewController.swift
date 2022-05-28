//
//  BaseViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log
import ProgressHUD
import Toast_Swift

class BaseViewController: UIViewController {
    let Log = Logger()
    
    //MARK: - NavigationBar
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
    
    //MARK: - Reachability
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
    
    //MARK: - Toast
    func showToast(_ aString:String)
    {
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.backgroundColor = Constants.APP_SECONDARY_COLOR
        style.messageColor = UIColor.white
        style.messageFont = UIFont.systemFont(ofSize: Constants.TOAST_FONT_SIZE)

        // present the toast with the new style
        self.view.makeToast(aString,
                            duration: Constants.TOAST_FONT_DURATION,
                            position: .center,
                            style: style)
    }
}
