//
//  lastIntroduction.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/14/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit

class lastIntroduction: UICollectionViewCell {
    

    @IBOutlet weak var startedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startedButton.layer.cornerRadius = 10;
    }

}
