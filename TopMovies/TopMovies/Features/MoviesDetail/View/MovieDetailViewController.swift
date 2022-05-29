//
//  MovieDetailViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 24/5/22.
//

import UIKit

class MovieDetailViewController: BaseViewController
{
    //MARK: - Properties
    @IBOutlet weak var iImageViewBackgroundError: UIImageView!
    @IBOutlet weak var iLabelCasting: UILabel!
    @IBOutlet weak var iScrollViewGeneral: UIScrollView!
    
    @IBOutlet weak var iViewContainerBackdrop: UIView!
    @IBOutlet weak var iImageViewBackdrop: UIImageView!
    @IBOutlet weak var iContraintBackdropHeight: NSLayoutConstraint!
    
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
        customLabel.text = self.iMovie?.iTitle
        customLabel.textColor = UIColor.white
        customLabel.font = UIFont.boldSystemFont(ofSize: Constants.NAVIGATION_BAR_TITLE_FONT_SIZE)
        customLabel.textColor = UIColor.white
        customLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        customLabel.layer.shadowOpacity = 1
        customLabel.layer.shadowRadius = 3
        customLabel.layer.shadowColor = Constants.APP_PRIMARY_COLOR.cgColor
        customLabel.numberOfLines = 2
        customLabel.adjustsFontSizeToFitWidth = true
        customLabel.minimumScaleFactor = 0.5
        customLabel.textAlignment = .center
        
        navigationItem.titleView = customLabel
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let backImage = Constants.NAVIGATION_BAR_BACK_ICON_IMAGE
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(onBackPressed))
    }
    
    func showBackgroundError(forCustomError aCustomError:CustomError)
    {
        self.iImageViewBackgroundError.image = aCustomError.errorImage
        self.iImageViewBackgroundError.isHidden = false
        self.showToast(aCustomError.description)
    }
    
    func hideBackgroundError()
    {
        self.iImageViewBackgroundError.isHidden = true
    }

    func setupMovieDetail()
    {
        guard let movie = self.iMovie,
              let movieDetail = self.iMovie?.iMovieDetail
        else {
            Log.warning("NO MOVIE OR MOVIE DETAIL")
            self.showBackgroundError(forCustomError: CustomError.genericError)
            return
        }
        self.iLabelCasting.text = NSLocalizedString("Casting", comment: "")
        
        //BACKDROP
        self.setBackdropImage(movieDetail.iBackdropImage)
        //TITLE
        self.setTitle(movie.iTitle)
        //RELEASE DATE & RUNTIME
        self.setReleaseDate(movie.iReleaseDate, andRuntime: movieDetail.iRuntime)
        //RATING
        self.setVoteAverage(movie.iVoteAverage)
        //GENRES
        self.setGenersList(movieDetail.iGenres)
        //TAGLINE
        self.setTagLine(movieDetail.iTagline)
        //OVERVIEW
        self.setOverview(movieDetail.iOverview)
        //POSTER
        self.setPoster(movie.iPosterImage)
    }
    private func setBackdropImage(_ aBackdropImage:UIImage?)
    {
        if let backdropImage = aBackdropImage
        {
            self.iImageViewBackdrop.image = backdropImage
            self.iImageViewBackdrop.contentMode = .scaleAspectFill
        }
        else
        {
            self.iImageViewBackdrop.image = UIImage(named: Constants.COLLECTION_VIEW_CELL_NO_IMAGE)
        }
    }
    private func setTitle(_ aTitle:String?)
    {
        self.iLabelTitle.text = aTitle ?? ""
        self.iLabelTitle.font = self.iLabelTitle.font.bold
        let maxLines = self.iLabelTitle.maxNumberOfLines
        
        let multiplier = (maxLines == 1 ? Constants.TITLE_GENERS_CONSTRAIN_MULTIPLIER_1 : Constants.TITLE_GENERS_CONSTRAIN_MULTIPLIER_2)
        let newConstraint = self.iConstraintViewTitleToGeners.constraintWithMultiplier(multiplier)
        self.iViewMovieDetail.changeConstraint(self.iConstraintViewTitleToGeners,
                                               for: newConstraint)
        self.iConstraintViewTitleToGeners = newConstraint
    }
    private func setReleaseDate(_ aReleaseDate:String?, andRuntime aRuntime:Int?)
    {
        var releaseDateRuntimeAppend:String = ""
        releaseDateRuntimeAppend += Utils.getFormattedDateByCountry(aReleaseDate, withFormat: Constants.API_RESULTS_RELEASE_DATE_FORMAT)
        if aRuntime != nil
        {
            releaseDateRuntimeAppend += " - "
        }
        releaseDateRuntimeAppend += Utils.getFormattedTime(aRuntime)
        
        self.iLabelReleaseDateRuntime.text = releaseDateRuntimeAppend
    }
    private func setVoteAverage(_ aVoteAverage:Double?)
    {
        let alpha = Constants.COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA
        
        if let voteAverage = aVoteAverage
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
            self.iLabelRating.layer.borderColor = Utils.getAppGradientColor(forView: self.iLabelRating).withAlphaComponent(alpha).cgColor
        }
        else
        {
            self.iViewContainerRating.backgroundColor = UIColor.clear
            self.iLabelRating.text = ""
        }
    }
    private func setGenersList(_ aGenersList:[Geners]?)
    {
        var genresAppend:String = ""
        if let genresList = aGenersList
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
    }
    private func setTagLine(_ aTagLine:String?)
    {
        self.iLabelTagline.text = aTagLine ?? ""
        self.iLabelTagline.font = self.iLabelTagline.font.italic
    }
    private func setOverview(_ aOverview:String?)
    {
        self.iLabelOverview.text = aOverview ?? ""
        let overviewMaxLines = self.iLabelOverview.maxNumberOfLines
        
        var multiplier = Constants.OVERVIEW_CONSTRAIN_MULTIPLIER_5
        if overviewMaxLines <= 5
        {
            multiplier = Constants.OVERVIEW_CONSTRAIN_MULTIPLIER_1
        }
        else if overviewMaxLines < 8 && overviewMaxLines > 5
        {
            multiplier = Constants.OVERVIEW_CONSTRAIN_MULTIPLIER_2
        }
        else if overviewMaxLines <= 11 && overviewMaxLines >= 8
        {
            multiplier = Constants.OVERVIEW_CONSTRAIN_MULTIPLIER_3
        }
        else if overviewMaxLines <= 15 && overviewMaxLines >= 12
        {
            multiplier = Constants.OVERVIEW_CONSTRAIN_MULTIPLIER_4
        }
        
        let newConstraint = self.iConstraintViewTaglineOverview.constraintWithMultiplier(multiplier)
        self.iViewMovieDetail.changeConstraint(self.iConstraintViewTaglineOverview,
                                               for: newConstraint)
        self.iConstraintViewTaglineOverview = newConstraint

    }
    private func setPoster(_ aPosterImage:UIImage?)
    {
        if let posterImage = aPosterImage
        {
            self.iImageViewPoster.image = posterImage
        }
    }
    
    //MARK: - UICollectionView
    func reloadCollectionViews()
    {
        self.iCollectionViewCrew.reloadItems(at: self.iCollectionViewCrew.indexPathsForVisibleItems)
        self.iCollectionViewCast.reloadItems(at: self.iCollectionViewCast.indexPathsForVisibleItems)
    }
    func reloadCastCollectionView(forIndexPath aIndexPath:IndexPath)
    {
        self.iCollectionViewCast.reloadItems(at: [aIndexPath])
    }
    
    //MARK: - Selectors
    @objc func onBackPressed()
    {
        Log.info(#function)
        self.popViewController()
    }
}

//MARK: - UICollectionViewDataSource
extension MovieDetailViewController:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.iCollectionViewCast
        {
            let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as! CastCollectionViewCell
        
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
            let crewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CrewCollectionViewCell.identifier,
                                                          for: indexPath) as! CrewCollectionViewCell
            guard indexPath.row < self.iCrewList.count
            else
            {
                Log.warning("Cant acces to iCrewList(\(self.iCrewList.count)) index: \(indexPath.row)")
                crewCell.setupCellDefault()
                return crewCell
            }
            crewCell.setupCell(withCrew: self.iCrewList[indexPath.row])
            
            return crewCell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
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
            
            let itemSize = CGSize(width: width/4, height: (width/4)*Constants.COLLECTION_VIEW_CELL_ASPECT_RATIO)
            return itemSize
        }
        return CGSize(width: 0, height: 0)
    }
}
