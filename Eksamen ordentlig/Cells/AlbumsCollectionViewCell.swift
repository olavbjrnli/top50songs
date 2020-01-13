//
//  AlbumsCollectionViewCell.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 31/10/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var artistLbl: UILabel!
    @IBOutlet var albumLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
