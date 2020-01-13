//
//  trackTableViewCell.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 01/11/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

class trackTableViewCell: UITableViewCell {

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
