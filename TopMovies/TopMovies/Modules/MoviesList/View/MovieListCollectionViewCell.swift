//
//  MovieListCollectionViewCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var iImageViewPoster: UIImageView!
    @IBOutlet weak var iViewContainerTitleReleaseDate: UIView!
    @IBOutlet weak var iLabelTitle: UILabel!
    @IBOutlet weak var iLabelReleaseDate: UILabel!
    
    @IBOutlet weak var iViewContainerRating: UIView!
    @IBOutlet weak var iLabelRating: UILabel!
}
