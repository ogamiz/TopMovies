//
//  BaseRouter.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Log

class BaseRouter: NSObject
{
    let Log = Logger()
    
    static var mainStoryboard: UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
