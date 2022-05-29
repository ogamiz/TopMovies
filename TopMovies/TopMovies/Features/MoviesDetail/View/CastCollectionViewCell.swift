//
//  CastCollectionCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 26/5/22.
//

import UIKit

class CastCollectionViewCell: BaseCollectionViewCell
{
    @IBOutlet weak var iImageViewProfile: UIImageView!
    @IBOutlet weak var iLabelName: UILabel!
    @IBOutlet weak var iLabelCharacter: UILabel!
    @IBOutlet weak var iIndicatorImageStatus: UIActivityIndicatorView!
    
    func setupCellDefault()
    {
        self.iLabelName.text = ""
        self.iLabelCharacter.text = ""
        self.iImageViewProfile.image = Utils.resizeImage(UIImage(color: .white)!,
                                                         withSize: self.frame.size)
    }
    
    func setupCell(withCast aCast:Cast)
    {
        self.iLabelName.text = aCast.iName ?? ""
        self.iLabelCharacter.text = aCast.iCharacter ?? ""
        
        if let profileImage = aCast.iProfileImage
        {
            self.iImageViewProfile.image = profileImage
            self.stopIndicator()
        }
        else if aCast.iProfileImageStatus == .completed
        {
            self.iImageViewProfile.image = UIImage(named: Constants.COLLECTION_VIEW_CELL_NO_IMAGE)!
            self.stopIndicator()
        }
        else
        {
            self.iImageViewProfile.image = Utils.resizeImage(UIImage(color: .white)!,
                                                             withSize: self.frame.size)
            self.startIndicator()
        }
    }
    
    func startIndicator()
    {
        self.iIndicatorImageStatus.startAnimating()
        self.iIndicatorImageStatus.transform = CGAffineTransform(scaleX: 2.0,
                                                                 y: 2.0)
        self.iIndicatorImageStatus.color = Constants.APP_PRIMARY_COLOR
    }
    func stopIndicator()
    {
        self.iIndicatorImageStatus.stopAnimating()
        self.iIndicatorImageStatus.isHidden = true
    }
}
