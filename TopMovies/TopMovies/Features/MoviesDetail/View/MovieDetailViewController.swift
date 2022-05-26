//
//  MovieDetailViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

class MovieDetailViewController:
    BaseViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    //MARK: - Properties
    @IBOutlet weak var iImageViewBackdrop: UIImageView!
    
    @IBOutlet weak var iViewMovieDetail: UIView!
    @IBOutlet weak var iConstraintViewTitleToGeners: NSLayoutConstraint!
    @IBOutlet weak var iLabelTitle: UILabel!
    @IBOutlet weak var iLabelReleaseDateRuntime: UILabel!
    @IBOutlet weak var iLabelGenres: UILabel!
    @IBOutlet weak var iViewContainerRating: UIView!
    @IBOutlet weak var iLabelRating: UILabel!
    
    @IBOutlet weak var iConstraintViewTaglineOverview: NSLayoutConstraint!
    @IBOutlet weak var iLabelTagline: UILabel!
    @IBOutlet weak var iLabelOverview: UILabel!
    
    @IBOutlet weak var iCollectionViewCrew: UICollectionView!
    
    @IBOutlet weak var iCollectionViewCast: UICollectionView!
    
    @IBOutlet weak var iImageViewPoster: UIImageView!
    
    //MARK: - Variables
    var iPresenter:MovieDetailPresenter!
    
    var iMovie:Movie?
    
    var iCrewList:[Crew] = []
    var iCastList:[Cast] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad()
    {
        Log.info(#function)
        super.viewDidLoad()
        self.iPresenter.onViewDidLoad()
    }
    
    //MARK: - Interface Methods
    override func setupNavigationBar() {
        Log.info(#function)
        //Setup NavBar basics
        super.setupNavigationBar()
        
        //Set NavBar title
        let customLabel = UILabel()
        customLabel.text = Constants.NAVIGATION_BAR_TITLE_MOVIESLITVC
        customLabel.textColor = UIColor.white
        customLabel.font = UIFont.boldSystemFont(ofSize: Constants.NAVIGATION_BAR_TITLE_FONT_SIZE)
        customLabel.textColor = UIColor.white
        customLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        customLabel.layer.shadowOpacity = 1
        customLabel.layer.shadowRadius = 3
        customLabel.layer.shadowColor = Constants.APP_PRIMARY_COLOR.cgColor
        
        navigationItem.titleView = customLabel
    }
    
    func setupUI()
    {
        
    }
    
    func setupMovieDetail()
    {
        guard let movie = self.iMovie,
              let movieDetail = self.iMovie?.iMovieDetail
        else {
            //TODO: Show emptyIcon
            return
        }
        
        //BACKDROP
        if let backdropImage = movieDetail.iBackdropImage
        {
            self.iImageViewBackdrop.image = backdropImage
            self.iImageViewBackdrop.contentMode = .scaleAspectFill
        }
        else
        {
            //TODO: add backdrop no image image
        }
        
        //TITLE
        self.iLabelTitle.text = movie.iTitle ?? ""
        self.iLabelTitle.font = self.iLabelTitle.font.bold
        let maxLines = self.iLabelTitle.maxNumberOfLines
        
        let newConstraintTitleToGeners = self.iConstraintViewTitleToGeners.constraintWithMultiplier(maxLines == 1 ? 0.14 : 0.18)
        self.iViewMovieDetail.removeConstraint(self.iConstraintViewTitleToGeners)
        self.iViewMovieDetail.addConstraint(newConstraintTitleToGeners)
        self.iViewMovieDetail.layoutIfNeeded()
        self.iConstraintViewTitleToGeners = newConstraintTitleToGeners
        
        //RELEASE DATE & RUNTIME
        var releaseDateRuntimeAppend:String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let releaseDate = movie.iReleaseDate,
           let date = dateFormatter.date(from: releaseDate)
        {
            let dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd",
                                                      options: 0,
                                                      locale: Locale.current)
            dateFormatter.dateFormat = dateFormat
            
            releaseDateRuntimeAppend += dateFormatter.string(from: date)
        }
        if let runtime = movieDetail.iRuntime
        {
            releaseDateRuntimeAppend += " - \(runtime)m"
        }
        self.iLabelReleaseDateRuntime.text = releaseDateRuntimeAppend
        
        //RATING
        let alpha = Constants.COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA
        
        if let voteAverage = movie.iVoteAverage
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
        
        //GENRES
        var genresAppend:String = ""
        if let genresList = movieDetail.iGenres
        {
            for (idx, genres) in genresList.enumerated()
            {
                if let name = genres.iName
                {
                    genresAppend += name + (idx != genresList.endIndex-1 ? ", " : "")
                }
            }
        }
        self.iLabelGenres.text = genresAppend
        
        //TAGLINE
        self.iLabelTagline.text = movieDetail.iTagline ?? ""
        self.iLabelTagline.font = self.iLabelTagline.font.italic
        
        //OVERVIEW
        self.iLabelOverview.text = movieDetail.iOverview ?? ""
        let overviewMaxLines = self.iLabelOverview.maxNumberOfLines
        
        var multiplier = 0.35
        if overviewMaxLines <= 5
        {
            multiplier = 0.15
        }
        else if overviewMaxLines < 8 && overviewMaxLines > 5
        {
            multiplier = 0.2
        }
        else if overviewMaxLines <= 11 && overviewMaxLines >= 8
        {
            multiplier = 0.25
        }
        else if overviewMaxLines <= 15 && overviewMaxLines >= 12
        {
            multiplier = 0.3
        }
        
        let newConstraintTaglineOverview = self.iConstraintViewTaglineOverview.constraintWithMultiplier(multiplier)
        self.iViewMovieDetail.removeConstraint(self.iConstraintViewTaglineOverview)
        self.iViewMovieDetail.addConstraint(newConstraintTaglineOverview)
        self.iViewMovieDetail.layoutIfNeeded()
        self.iConstraintViewTaglineOverview = newConstraintTaglineOverview
        
        //POSTER
        if let posterImage = movie.iPosterImage
        {
            self.iImageViewPoster.image = posterImage
        }
        else
        {
            //TODO: add poster no image image
        }
    }
    
    //MARK: - UICollectionView
    func reloadCollectionViews()
    {
        self.iCollectionViewCrew.reloadItems(at: self.iCollectionViewCrew.indexPathsForVisibleItems)
        self.iCollectionViewCast.reloadItems(at: self.iCollectionViewCast.indexPathsForVisibleItems)
    }
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.iCollectionViewCast
        {
            return self.iCastList.count
        }
        else if collectionView == self.iCollectionViewCrew
        {
            return self.iCrewList.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.iCollectionViewCast
        {
            let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.COLLECTION_VIEW_CELL_CAST_IDENTIFIER,
                                                          for: indexPath) as! CastCollectionViewCell
        
            //Avoid outOfIndex case
            guard indexPath.row < self.iCastList.count
            else
            {
                Log.warning("Cant acces to iCastList(\(self.iCastList.count)) index: \(indexPath.row)")
                castCell.setupCellDefault()
                return castCell
            }
            self.iPresenter.onCollectionView(cellForItemAt: indexPath)
            castCell.setupCell(withCast: self.iCastList[indexPath.row])
            
            return castCell
        }
        else if collectionView == self.iCollectionViewCrew
        {
            let crewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.COLLECTION_VIEW_CELL_CREW_IDENTIFIER,
                                                          for: indexPath) as! CrewCollectionViewCell
            guard indexPath.row < self.iCrewList.count
            else
            {
                Log.warning("Cant acces to iCrewList(\(self.iCrewList.count)) index: \(indexPath.row)")
                crewCell.setupCellDefault()
                return crewCell
            }
            self.iPresenter.onCollectionView(cellForItemAt: indexPath)
            crewCell.setupCell(withCrew: self.iCrewList[indexPath.row])
            
            return crewCell
        }
        return UICollectionViewCell()
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.iCollectionViewCast
        {
            let heigth = self.iCollectionViewCast.frame.height
            let width = self.iCollectionViewCast.frame.width
            
            let itemSize = CGSize(width: width/3, height: heigth)
            return itemSize
        }
        else if collectionView == self.iCollectionViewCrew
        {
            let width = self.iCollectionViewCast.frame.width
            
            let itemSize = CGSize(width: width/4, height: (width/4)*1.66)
            return itemSize
        }
        return CGSize(width: 0, height: 0)
    }
}
