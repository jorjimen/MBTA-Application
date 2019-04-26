//
//  TableViewCell.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/14/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit

class trainStopsCell: UITableViewCell {

    
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var lineDest: UILabel!
    @IBOutlet weak var lineColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineColor.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
