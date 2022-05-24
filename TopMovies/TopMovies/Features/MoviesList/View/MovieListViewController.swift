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
    var iPresenter:MovieListPresenter!
    
    var iMovieList:[Movie] = []
    var iCurrentPage:Int = 0
    var iTotalPages:Int = 0
    
    var iCollectionCellSize:CGSize = Constants.COLLECTION_VIEW_CELL_DEFAULT_SIZE
    var iLoadingCollectionCellSize:CGSize = Constants.COLLECTION_VIEW_CELL_LOADING_DEFAULT_SIZE
    var iCollectionCellsSizeSetted:Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        Log.info(#function)
        super.viewDidLoad()
        self.iPresenter.onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.iPresenter.onViewWillLayoutSubviews()
    }
    
    func collectionViewInvalidateLayout()
    {
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
    func reloadCollectionView()
    {
        self.iCollectionViewMovies.reloadItems(at: self.iCollectionViewMovies.indexPathsForVisibleItems)
    }
    func reloadCollectionView(forIndexList aIndexPathList:[IndexPath])
    {
        self.iCollectionViewMovies.reloadItems(at: aIndexPathList)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.iMovieList.count + (self.iCurrentPage < self.iTotalPages ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //Loading CollectionCell
        if self.iCurrentPage < self.iTotalPages &&
            indexPath.row == self.iMovieList.count
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.COLLECTION_VIEW_CELL_LOADING_IDENTIFIER,
                                                          for: indexPath) as! LoadingMovieCollectionCell
            cell.startAnimation()
            return cell
        }
        else //Standar CollectionCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.COLLECTION_VIEW_CELL_IDENTIFIER,
                                                          for: indexPath) as! MovieListCollectionCell
            //Avoid outOfIndex case
            guard indexPath.row < self.iMovieList.count
            else
            {
                Log.warning("Cant acces to iMovieList(\(self.iMovieList.count)) index: \(indexPath.row)")
                cell.setupCellDefault(withSize: self.iCollectionCellSize)
                return cell
            }
            self.iPresenter.onCollectionView(cellForItemAt: indexPath)
            
            let movie = self.iMovieList[indexPath.row]
            cell.setupCell(withMovie: movie,
                           withSize: self.iCollectionCellSize)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        self.iPresenter.onCollectionView(willDisplayCellForItemAt: indexPath)
    }

    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        self.iPresenter.onCollectionView(sizeForItemAt: indexPath)
        
        //Custom Size for LoadingCell
        if self.iCurrentPage < self.iTotalPages &&
            indexPath.row == self.iMovieList.count
        {
            return self.iLoadingCollectionCellSize
        }
        else //Standar Size for CollectionCell
        {
            return self.iCollectionCellSize
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
