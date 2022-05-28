//
//  MoviesListViewController.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 22/5/22.
//

import UIKit

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
    @IBOutlet weak var iImageViewBackgroundError: UIImageView!
    
    @IBOutlet weak var iCollectionViewMovies: UICollectionView!
    
    //MARK: - Variables
    var iPresenter:MovieListPresenter?
    
    var iMovieList:[Movie] = []
    var iCurrentPage:Int = 0
    var iTotalPages:Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        Log.info(#function)
        super.viewDidLoad()
        self.iPresenter?.onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.iPresenter?.onViewWillLayoutSubviews()
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
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.iPresenter?.onSearchBar(textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.iPresenter?.onSearchBarSearchButtonClicked()
    }
    
    //MARK: - UICollectionVie
    func collectionViewScrollToTop()
    {
        self.iCollectionViewMovies.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
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
                cell.setupCellDefault()
                return cell
            }
            
            cell.setupCell(withMovie: self.iMovieList[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        self.iPresenter?.onCollectionView(willDisplayCellForItemAt: indexPath)
    }

    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let colums:CGFloat = Utils.getNumberOfColumns()
        let width = self.iCollectionViewMovies.frame.size.width
        
        let aspectRatio = Constants.COLLECTION_VIEW_CELL_ASPECT_RATIO
        let itemWidth = width / colums
        
        return CGSize(width: itemWidth, height: itemWidth * aspectRatio)
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.iPresenter?.onCollectionView(didSelectItemAt: indexPath)
    }
    
    //MARK: - SELECTORS
    @objc func onSettingsPressed()
    {
        self.iPresenter?.onSettingsPressed()
    }
    
    // MARK: - Navigation
    func navigationPush(viewController aViewController:UIViewController)
    {
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
}
