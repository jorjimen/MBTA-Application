//
//  CollectionViewCell.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/14/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit

class introductionCell: UICollectionViewCell {
    
    @IBOutlet weak var clickHere: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let goTo = UITapGestureRecognizer(target: self, action: Selector(("goTo:")))
        clickHere.addGestureRecognizer(goTo)
    }
    
    @objc func goTo(sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.mbta.com") else { return }
        UIApplication.shared.open(url)
    }
}
