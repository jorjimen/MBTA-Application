//
//  IntroductionController.swift
//  MBTA Application
//
//  Created by Jorge Andres on 1/14/19.
//  Copyright © 2019 Jorge Jimenez. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreData

class IntroductionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = UIColor(hexString: "5e65fb")
        pc.pageIndicatorTintColor = UIColor(hexString: "cfd3fb")
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIntro()
    }
    
    private func setUpIntro() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        let nibOne = UINib(nibName: "introductionCell", bundle: nil)
        let nibTwo = UINib(nibName: "introductionCell2", bundle: nil)
        let nibLast = UINib(nibName: "lastIntroduction", bundle: nil)
        collectionView.register(nibOne, forCellWithReuseIdentifier: "introductionCell")
        collectionView.register(nibTwo, forCellWithReuseIdentifier: "introductionCell2")
        collectionView.register(nibLast, forCellWithReuseIdentifier: "lastIntroduction")
        collectionView.isPagingEnabled = true
        view.addSubview(pageControl)
        pageControl.center = CGPoint(x: view.center.x, y: (view.frame.height - 35))
        // let defaults = UserDefaults.standard
        // defaults.set(true, forKey: "DidPassTutorial")
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introductionCell", for: indexPath) as! introductionCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introductionCell2", for: indexPath) as! introductionCell2
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lastIntroduction", for: indexPath) as! lastIntroduction
            cell.startedButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func continueAction() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "DidShowTutorial")
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = targetContentOffset.pointee.x
        pageControl.currentPage = Int(point/view.frame.size.width)
    }
    
}
