//
//  NewsCellTableViewCell.swift
//  MBTA Application
//
//  Created by Jorge Andres on 6/13/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit

class NewsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newImage.clipsToBounds = true
        newImage.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
