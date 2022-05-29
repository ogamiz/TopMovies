//
//  BaseTableViewCell.swift
//  TopMovies
//
//  Created by Oscar Gamiz on 29/5/22.
//

import UIKit
import Log

class BaseTableViewCell: UITableViewCell
{
    //MARK: - Variables
    let Log = Logger()
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
