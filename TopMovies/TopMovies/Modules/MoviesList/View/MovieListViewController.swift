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
        super.setupNavigationBar()
        //Set NavBar title
        navigationItem.title = Constants.NAVIGATION_BAR_TITLE_MOVIESLITVC
        
        //Set NavBar button settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.NAVIGATION_BAR_SETTINGS_ICON_IMAGE,
            style: .plain,
            target: self,
            action: #selector(onSettingsPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.APP_TERTIARY_COLOR
    }
    
    func setupUI()
    {
        //CollectionView
        
//        //SearchButton animated icon
//        let margin = 8.0
//        let searchButtonFrame = self.iViewContainerSearchButton.frame
//        self.iSearchButton.animation = Animation.named("searchButton")
//        self.iSearchButton.frame = CGRect(x: margin, y: margin, width: searchButtonFrame.width - margin, height: searchButtonFrame.height - margin)
//        self.iSearchButton.backgroundColor = UIColor.clear
////        self.iSearchButton.center = self.iViewContainerSearchButton.center
//        self.iSearchButton.contentMode = .scaleAspectFit
//        self.iSearchButton.loopMode = .loop
//        self.iSearchButton.play()
////        view.addSubview(self.iSearchButton)
//        self.iViewContainerSearchButton.addSubview(self.iSearchButton)
//
//        //SearchButton gesture recognizer
//        let searchButtonOnTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSearchButtonPressed))
//        self.iSearchButton.addGestureRecognizer(searchButtonOnTapGesture)
    }
    
    //MARK: - UICollectionVie
    func reloadCollectionView()
    {
        if Thread.isMainThread
        {
            self.iCollectionViewMovies.reloadData()
        }
        else
        {
            DispatchQueue.main.async {
                self.iCollectionViewMovies.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieListCollectionViewCell
        
        if indexPath.row < self.iMovieList.count
        {
            let movie = self.iMovieList[indexPath.row]
            //ContainerView: Title & Release Date
            cell.iViewContainerTitleReleaseDate.backgroundColor = Constants.APP_TERTIARY_COLOR.withAlphaComponent(0.7)
            //Title
            cell.iLabelTitle.text = movie.iTitle ?? ""
            cell.iLabelTitle.textColor = UIColor.white
            //Release Date
            cell.iLabelReleaseDate.text = movie.iReleaseDate ?? ""
            cell.iLabelReleaseDate.textColor = UIColor.white
            //Poster
            if let posterImage = movie.iPosterImage
            {
                cell.iImageViewPoster.image = posterImage
            }
            else
            {
                if let posterPath = movie.iPosterPath
                {
                    self.iPresenter?.fetchPosterImage(withPath: posterPath, forCellIndexPath: indexPath)
                }
            }
            //Vote Average
            if let voteAverage = movie.iVoteAverage
            {
                cell.iLabelRating.text = String(format: "%0.1f", voteAverage)
            }
            else
            {
                cell.iLabelRating.text = ""
            }
        }
        else
        {
            Log.warning("Cant acces to iMovieList(\(self.iMovieList.count)) index: \(indexPath.row)")
            cell.iLabelTitle.text = ""
            cell.iLabelReleaseDate.text = ""
            cell.iLabelRating.text = ""
        }
        
        return cell
    }
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var colums:CGFloat
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight
        {
            colums = Constants.COLLECTION_VIEW_NUM_COMUNS_LANDSCAPE
        }
        else
        {
            colums = Constants.COLLECTION_VIEW_NUM_COMUNS_PORTRAIT
        }
        
        let spacing:CGFloat = Constants.COLLECTION_VIEW_SPACING
        let totalHorizontalSpacing = (colums - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / colums
        let itemSize = CGSize(width: itemWidth, height: itemWidth * Constants.COLLECTION_VIEW_CELL_ASPECT_RATIO)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.COLLECTION_VIEW_SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.COLLECTION_VIEW_SPACING
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
