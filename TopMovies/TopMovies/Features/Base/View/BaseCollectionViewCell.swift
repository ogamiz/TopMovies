//
//  BaseCollectionViewCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit
import Log

class BaseCollectionViewCell: UICollectionViewCell
{
    //MARK: - Variables
    let Log = Logger()
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
}
