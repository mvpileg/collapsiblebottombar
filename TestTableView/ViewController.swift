//
//  ViewController.swift
//  TestTableView
//
//  Created by Matthew Pileggi on 2/18/20.
//  Copyright © 2020 Matthew Pileggi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var bottomBarTopConstraint: NSLayoutConstraint!
    var previousOffset: CGFloat = 0
    var userIsPanning = false
    
    var test: CollapsibleBottomBarPositionManager!
    
    enum BottomBarState {
        case show
        case hide
        case transition
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("INSET \(tableView.contentInset)")
        print("Initial offset \(tableView.contentOffset)")
        setupBottomBar()
    }
    
    private func setupBottomBar() {
        let bottomBar = UIView()
        bottomBar.backgroundColor = UIColor.gray
        
        view.addSubview(bottomBar)

        bottomBarTopConstraint = bottomBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0)

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 100.0),
            bottomBarTopConstraint
            ])
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        test = CollapsibleBottomBarPositionManager(bottomBarHeight: 50, scrollView: tableView, delegate: self)
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        test.scrollViewWillBeginDragging(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        test.scrollViewDidScroll(scrollView)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging")
        test.scrollViewWillEndDragging(scrollView, withVelocity: velocity)
    }
  
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        test.scrollViewDidEndDragging(scrollView, didUserSlingIt: decelerate)
//    }
    
}

extension ViewController: CollapsibleBottomBarPositionDelegate {
    
    func bottomBarPositionShouldChange(to value: CGFloat, animated: Bool) {
        bottomBarTopConstraint.constant = -value
        
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
        print("BOTTOM BAR POSITION DID CHANGE \(value)")
    }

}



//    //need to track all three of these...
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        previousOffset = scrollView.contentOffset.y
//        userIsPanning = true
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("ScrollViewDidEndDragging")
//
//        //determine if we should be up or down
//        userIsPanning = false
//    }

//func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print("scrollViewDidScroll to: \(scrollView.contentOffset.y)")
    //        print()
    //        guard userIsPanning else {
    //            return
    //        }
    //
    //        let currentOffset = scrollView.contentOffset.y
    //        let delta = currentOffset - previousOffset
    //
    ////        print("PREVIOUS \(previousOffset), CURRENT \(currentOffset), DELTA \(delta)")
    //
    ////        bottomBarTopConstraint.constant = calculateNewBottomBarConstant(for: delta)
    //
    //        previousOffset = currentOffset
//}
//func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    //        print("ScrolViewDidScrollToTop")
//}

//    private func calculateNewBottomBarConstant(for delta: CGFloat) -> CGFloat {
//        let proposedTopConstraintConstant = bottomBarTopConstraint.constant + delta
//
//        let min: CGFloat = -100
//        let max: CGFloat = 0
//
//        if proposedTopConstraintConstant < min {
//            return min
//        } else if proposedTopConstraintConstant > max {
//            return max
//        } else {
//            return proposedTopConstraintConstant
//        }
//    }




