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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.APP_PRIMARY_COLOR
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.APP_TERTIARY_COLOR, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: Constants.NAVIGATION_BAR_TITLE_FONT_SIZE)]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
