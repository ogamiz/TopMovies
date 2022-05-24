//
//  MoviesListViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit
import Lottie

class MovieListViewController:
    BaseViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate
{
    //MARK: - Properties
    @IBOutlet weak var iSearchBar: UISearchBar!
    @IBOutlet weak var iViewContainerMovieList: UIView!
    
    @IBOutlet weak var iCollectionViewMovies: UICollectionView!
    
    //MARK: - Variables
    var iPresenter:MovieListPresenter?
    
    var iMovieList:[Movie] = []
    
    var iCollectionCellSize:CGSize?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        Log.info(#function)
        super.viewDidLoad()
        self.iPresenter?.onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.iCollectionViewMovies.collectionViewLayout.invalidateLayout()
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
        
        //Set NavBar button settings
        let settingsImage = Constants.NAVIGATION_BAR_SETTINGS_ICON_IMAGE?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) ?? Constants.NAVIGATION_BAR_SETTINGS_DEFAULT_ICON_IMAGE
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: settingsImage,
            style: .plain,
            target: self,
            action: #selector(onSettingsPressed))
    }
    
    func setupUI()
    {

    }
    
    //MARK: - UICollectionVie
    func reloadCollectionView(_ aIndexPath:IndexPath? = nil)
    {
        if Thread.isMainThread
        {
            if let indexPath = aIndexPath
            {
                self.iCollectionViewMovies.reloadItems(at: [indexPath])
            }
            else
            {
                self.iCollectionViewMovies.reloadData()
            }
        }
        else
        {
            DispatchQueue.main.async {
                if let indexPath = aIndexPath
                {
                    self.iCollectionViewMovies.reloadItems(at: [indexPath])
                }
                else
                {
                    self.iCollectionViewMovies.reloadData()
                }
            }
        }
    }
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.iMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieListCollectionViewCell
        
        if indexPath.row < self.iMovieList.count
        {
            let movie = self.iMovieList[indexPath.row]
            
            if movie.iPosterImageStatus == .none
            {
                if let posterPath = movie.iPosterPath
                {
                    movie.iPosterImageStatus = .performing
                    self.iPresenter?.fetchPosterImage(withPath: posterPath, forCellIndexPath: indexPath)
                }
                else
                {
                    movie.iPosterImageStatus = .complete
                }
            }
            
            cell.setupCell(withMovie: movie, withSize: self.iCollectionCellSize)
        }
        else
        {
            Log.warning("Cant acces to iMovieList(\(self.iMovieList.count)) index: \(indexPath.row)")
            cell.setupCellDefault(withSize: self.iCollectionCellSize)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        self.iPresenter?.onCollectionViewSizeForItemAt()
        if let cellSize = self.iCollectionCellSize
        {
            return cellSize
        }
        else
        {
            Log.warning("NO COLLECTION CELL SIZE SET")
            return Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    
    //MARK: - SELECTORS
    @objc func onSettingsPressed()
    {
        Log.info(#function)
    }
    
    @objc func onSearchButtonPressed()
    {
        Log.info(#function)
    }
}

//MARK: - MovieListCollectionViewCell
class MovieListCollectionViewCell: UICollectionViewCell
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
    
    func setupCellDefault(withSize aSize:CGSize?)
    {
        var size = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
        if let sizeTemp = aSize
        {
            size = sizeTemp
        }
        let blankImage = Tools.resizeImage(UIImage(color: .white)!, withSize: size)
        self.iImageViewPoster.image = blankImage
        self.iViewContainerTitleReleaseDate.backgroundColor = UIColor.clear
        self.iLabelTitle.text = ""
        self.iLabelReleaseDate.text = ""
        self.iViewContainerRating.backgroundColor = UIColor.clear
        self.iLabelRating.text = ""
    }
    func setupCell(withMovie aMovie:Movie, withSize aSize:CGSize?)
    {
        let alpha = Constants.COLLECTION_VIEW_CELL_FLOATING_VIEW_ALPHA
        
        //ContainerView: Title & Release Date
        self.iViewContainerTitleReleaseDate.backgroundColor = Constants.APP_PRIMARY_COLOR.withAlphaComponent(alpha)
        
        //Title
        self.iLabelTitle.text = aMovie.iTitle ?? ""
        self.iLabelTitle.textColor = UIColor.white
        
        //Release Date
        self.iLabelReleaseDate.text = aMovie.iReleaseDate ?? ""
        self.iLabelReleaseDate.textColor = UIColor.white
        
        //Poster
        //Default blank poster with correct size
        var size = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
        if let sizeTemp = aSize
        {
            size = sizeTemp
        }
        let blankImage = Tools.resizeImage(UIImage(color: .white)!, withSize: size)
        self.iImageViewPoster.image = blankImage
        if aMovie.iPosterImageStatus == .complete
        {
            self.hiddeProgressIndicator() //Hide progress
            if let posterImage = aMovie.iPosterImage
            {
                //Set PosterImage and hide defaultPoster
                self.iImageViewPoster.image = posterImage
                self.hidePosterDefault()
            }
            else
            {
                //No image... Show defaultPoster
                self.showPosterDefault()
            }
        }
        else
        {
            self.hidePosterDefault()
            self.showProgressIndicator()
        }
        
        //Vote Average
        self.setupRatingView(withVoteAverage: aMovie.iVoteAverage)
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
            self.iLabelRating.layer.borderColor = Constants.APP_TERTIARY_COLOR.withAlphaComponent(alpha).cgColor
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
        self.iIndicatorProgesFetchPoster.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.iIndicatorProgesFetchPoster.isHidden = false
        self.iIndicatorProgesFetchPoster.startAnimating()
    }
    private func hiddeProgressIndicator()
    {
        self.iIndicatorProgesFetchPoster.isHidden = true
        self.iIndicatorProgesFetchPoster.stopAnimating()
    }
}

