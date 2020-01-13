//
//  DetailsTableViewCell.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 02/12/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    
    @IBOutlet var trackLbl: UILabel!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
