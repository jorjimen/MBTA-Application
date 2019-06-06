//
//  stopCell.swift
//  MBTA Application
//
//  Created by Jorge Andres on 5/29/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit

class stopCell: UITableViewCell {

    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var stopCircle: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var directionButton: UIButton!
    var isFirst = false
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var arrButton: UIButton!
    
    @IBOutlet weak var distanceFromUser: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stopCircle.layer.cornerRadius = stopCircle.frame.width / 2
        directionButton.layer.cornerRadius = 5
        arrButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
