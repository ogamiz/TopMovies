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

class BaseViewController: UIViewController
{
    //MARK: - Variables
    let Log = Logger()
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    //MARK: - NavigationBar
    func setupNavigationBar()
    {
        if let navigationBar = self.navigationController?.navigationBar
        {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Utils.getAppGradientColor(forView: navigationBar)
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    //MARK: - Navigation
    func popViewController()
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: true)
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
