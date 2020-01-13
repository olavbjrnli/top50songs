//
//  FavouriteTableViewCell.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 02/12/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet var artistLbl: UILabel!
    @IBOutlet var trackLbl: UILabel!
    @IBOutlet var durLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
