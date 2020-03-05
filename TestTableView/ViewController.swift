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
    var test2: CollapsibleBottomBarPositionManagerV2!
    
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
//        let toolbar = UIToolbar()
//        self.view.addSubview(toolbar)
//
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
//
//        toolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        toolbar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        toolbar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        toolbar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
//
//        self.navigationController?.toolbar = UIToolbar()
        let fab = UIView(frame: CGRect.zero)
        view.addSubview(fab)

        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.backgroundColor = UIColor.red
        
        fab.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fab.widthAnchor.constraint(equalToConstant: 50).isActive = true
        fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20.0).isActive = true
        fab.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20.0).isActive = true

        setToolbarItems([UIBarButtonItem(title: "test", style: .done, target: nil, action: nil)], animated: false)
        navigationController?.toolbar.frame = self.view.bounds
        
        self.navigationController?.hidesBarsOnSwipe = true
        
        return
        //inner bottom bar view
        let improvedBottomBar = UIView()
        improvedBottomBar.backgroundColor = UIColor.red
        test2 = CollapsibleBottomBarPositionManagerV2(bottomBar: improvedBottomBar, parentView: view, preferredHeight: 50.0)
        
        return
        let bottomBar = UIView()
        bottomBar.backgroundColor = UIColor.gray
        view.addSubview(bottomBar)
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomBar.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        
        
        
        
        
        bottomBarTopConstraint = bottomBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 100.0),
            bottomBarTopConstraint
            ])
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
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
//        test2.scrollViewDidChangeAdjustedContentInset(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        test2.scrollViewWillBeginDragging(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//          test2.scrollViewDidScroll(scrollView)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        test2.scrollViewWillEndDragging(scrollView, withVelocity: velocity)
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




