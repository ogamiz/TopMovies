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
    
    func setupCellDefault()
    {
        self.iLabelName.text = ""
        self.iLabelCharacter.text = ""
        self.iImageViewProfile.image = UIImage(named: "no_image")
    }
    
    func setupCell(withCast aCast:Cast)
    {
        self.iLabelName.text = aCast.iName ?? ""
        self.iLabelCharacter.text = aCast.iCharacter ?? ""
        
        if let profileImage = aCast.iProfileImage
        {
            self.iImageViewProfile.image = profileImage
        }
        else
        {
            self.iImageViewProfile.image = UIImage(named: "no_image")
        }
    }
}
