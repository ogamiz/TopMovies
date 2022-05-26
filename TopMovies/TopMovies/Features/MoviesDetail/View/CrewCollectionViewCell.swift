//
//  MovieDetailCollectionCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 26/5/22.
//

import UIKit

//MARK: CrewCollectionViewCell
class CrewCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var iLabelJob: UILabel!
    @IBOutlet weak var iLabelName: UILabel!
    
    func setupCellDefault()
    {
        self.iLabelName.text = ""
        self.iLabelJob.text = ""
    }
    
    func setupCell(withCrew aCrew:Crew)
    {
        self.iLabelName.text = aCrew.iName
        self.iLabelJob.text = aCrew.iJob
    }
}
