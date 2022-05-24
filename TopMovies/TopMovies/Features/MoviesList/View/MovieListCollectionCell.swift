//
//  MovieListCollectionCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

//MARK: - MovieListCollectionCell
class MovieListCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var iViewContainerDefaultPoster: UIView!
    @IBOutlet weak var iImageViewPoster: UIImageView!
    @IBOutlet weak var iViewContainerTitleReleaseDate: UIView!
    @IBOutlet weak var iLabelTitle: UILabel!
    @IBOutlet weak var iLabelReleaseDate: UILabel!
    
    @IBOutlet weak var iViewContainerRating: UIView!
    @IBOutlet weak var iLabelRating: UILabel!
    @IBOutlet weak var iImagePosterDefault: UIImageView!
    @IBOutlet weak var iIndicatorProgesFetchPoster: UIActivityIndicatorView!
    
    var iSize:CGSize = Constants.COLLECTION_VIEW_CELL_LOADING_DEFAULT_SIZE
    
    func setupCellDefault(withSize aSize:CGSize)
    {
        let blankImage = Tools.resizeImage(UIImage(color: .white)!, withSize: aSize)
        self.iImageViewPoster.image = blankImage
        self.iViewContainerTitleReleaseDate.backgroundColor = UIColor.clear
        self.iLabelTitle.text = ""
        self.iLabelReleaseDate.text = ""
        self.iViewContainerRating.backgroundColor = UIColor.clear
        self.iLabelRating.text = ""
        self.iLabelRating.layer.backgroundColor = UIColor.clear.cgColor
        self.iLabelRating.layer.borderColor = UIColor.clear.cgColor
    }
    func setupCell(withMovie aMovie:Movie, withSize aSize:CGSize)
    {
        self.iSize = aSize
        
        //ContainerView: Title & Release Date
        self.iViewContainerTitleReleaseDate.backgroundColor = Constants.APP_PRIMARY_COLOR.withAlphaComponent(Constants.COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA)
        
        //Title
        self.iLabelTitle.text = aMovie.iTitle ?? ""
        self.iLabelTitle.textColor = UIColor.white
        
        //Release Date
        self.setupReleaseDate(aMovie.iReleaseDate)
        
        //Poster
        self.setupPoster(forMovie: aMovie)
        
        //Vote Average
        self.setupRatingView(withVoteAverage: aMovie.iVoteAverage)
    }
    
    private func setupPoster(forMovie aMovie:Movie)
    {
        if let posterImage = aMovie.iPosterImage
        {
            //Set PosterImage and hide defaultPoster
            self.setPosterImage(Tools.resizeImage(posterImage, withSize: self.iSize))
            self.hidePosterDefault()
            self.hiddeProgressIndicator() //Hide progress
        }
        else
        {
            self.setPosterImage(Tools.resizeImage(UIImage(color: .white)!, withSize: self.iSize))
            if aMovie.iPosterImageStatus == .complete
            {
                //No image... Show Default blank poster with correct size
                self.showPosterDefault()
                self.hiddeProgressIndicator() //Hide progress
            }
            else
            {
                self.hidePosterDefault()
                self.showProgressIndicator()
            }
        }
    }
    private func setPosterImage(_ aImage:UIImage)
    {
        self.iImageViewPoster.image = aImage
    }
    private func setupReleaseDate(_ aReleaseDate:String?)
    {
        if let releaseDate = aReleaseDate
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: releaseDate)
            {
                let dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd",
                                                          options: 0,
                                                          locale: Locale.current)
                dateFormatter.dateFormat = dateFormat
                
                self.iLabelReleaseDate.text = dateFormatter.string(from: date)
            }
            else
            {
                self.iLabelReleaseDate.text = ""
            }
        }
        else
        {
            self.iLabelReleaseDate.text = ""
        }
        self.iLabelReleaseDate.textColor = UIColor.white
    }

    private func setupRatingView(withVoteAverage aVoteAverague:Double?)
    {
        let alpha = Constants.COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA
        
        if let voteAverage = aVoteAverague
        {
            let viewContainerSize:CGFloat = self.iViewContainerRating.frame.width //Aspect Ratio for view are 1:1
            self.iViewContainerRating.backgroundColor = Constants.APP_PRIMARY_COLOR.withAlphaComponent(alpha)
            self.iViewContainerRating.layer.cornerRadius = viewContainerSize / 2
            
            let labelSize:CGFloat = self.iLabelRating.frame.width //Aspect Ratio for view are 1:1
            self.iLabelRating.text = String(format: "%0.1f", voteAverage)
            self.iLabelRating.textColor = UIColor.white.withAlphaComponent(alpha)
            self.iLabelRating.layer.cornerRadius = labelSize / 2
            self.iLabelRating.layer.borderWidth = Constants.COLLECTION_VIEW_CELL_RATING_VIEW_BORDER
            self.iLabelRating.layer.backgroundColor = UIColor.clear.cgColor
           
            if let backgroundImageColor = CAGradientLayer.primaryGradient(
                on: self.iLabelRating,
                withInitialColor: Constants.APP_TERTIARY_COLOR,
                andFinishColor: Constants.APP_SECONDARY_COLOR)
            {
                self.iLabelRating.layer.borderColor =  UIColor(patternImage: backgroundImageColor).withAlphaComponent(alpha).cgColor
            }
            else
            {
                self.iLabelRating.layer.borderColor = Constants.APP_TERTIARY_COLOR.withAlphaComponent(alpha).cgColor
            }
        }
        else
        {
            self.iViewContainerRating.backgroundColor = UIColor.clear
            self.iLabelRating.text = ""
        }
    }
    
    private func showPosterDefault()
    {
        self.iImagePosterDefault.isHidden = false
    }
    private func hidePosterDefault()
    {
        self.iImagePosterDefault.isHidden = true
    }
    private func showProgressIndicator()
    {
        let indicatorScale = Constants.COLLECTION_VIEW_CELL_LOADING_INDICATOR_SCALE
        self.iIndicatorProgesFetchPoster.transform = CGAffineTransform(scaleX: indicatorScale,
                                                                       y: indicatorScale)
        self.iIndicatorProgesFetchPoster.color = Constants.APP_PRIMARY_COLOR
        self.iIndicatorProgesFetchPoster.isHidden = false
        self.iIndicatorProgesFetchPoster.startAnimating()
    }
    private func hiddeProgressIndicator()
    {
        self.iIndicatorProgesFetchPoster.isHidden = true
        self.iIndicatorProgesFetchPoster.stopAnimating()
    }
}
//MARK: - LoadingMovieCollectionCell
class LoadingMovieCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var iIndicatorProgesFetchNextPage: UIActivityIndicatorView!
    
    func startAnimation()
    {
        let indicatorScale = Constants.COLLECTION_VIEW_CELL_LOADING_INDICATOR_SCALE
        self.iIndicatorProgesFetchNextPage.startAnimating()
        self.iIndicatorProgesFetchNextPage.transform = CGAffineTransform(scaleX: indicatorScale,
                                                                         y: indicatorScale)
        self.iIndicatorProgesFetchNextPage.color = Constants.APP_PRIMARY_COLOR
    }
}
