//
//  BottomBarPositionManager.swift
//  TestTableView
//
//  Created by Matthew Pileggi on 2/18/20.
//  Copyright © 2020 Matthew Pileggi. All rights reserved.
//

import UIKit

protocol CollapsibleBottomBarPositionDelegate: class {

    func bottomBarPositionShouldChange(to value: CGFloat, animated: Bool)
    
}

class CollapsibleBottomBarPositionManager {
    
    private static let thresholdVelocityForPositionChanges: CGFloat = 1.0

    private let bottomBarHeight: CGFloat
    private var contentOffset: CGFloat
    private var bottomBarCurrentPosition: CGFloat
    private var isPanning = false
    
    private weak var delegate: CollapsibleBottomBarPositionDelegate?

    init(bottomBarHeight: CGFloat, scrollView: UIScrollView, delegate: CollapsibleBottomBarPositionDelegate) {
        self.bottomBarHeight = bottomBarHeight
        bottomBarCurrentPosition = bottomBarHeight
        contentOffset = scrollView.contentOffset.y
        self.delegate = delegate
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if isPanning {
            let maxPosition = maxBottomBarPosition(in: scrollView)
            let proposedPosition = proposedBottomBarPosition(in: scrollView)
            
            let newPosition = min(max(proposedPosition, -20), maxPosition)
            delegate?.bottomBarPositionShouldChange(to: newPosition, animated: false)
            bottomBarCurrentPosition = newPosition
        }
        contentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isPanning = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        let yVelocity = velocity.y
        let maxPosition = maxBottomBarPosition(in: scrollView)
        
        let newPosition: CGFloat
        if yVelocity > CollapsibleBottomBarPositionManager.thresholdVelocityForPositionChanges {
            newPosition = -20
        } else if yVelocity < -CollapsibleBottomBarPositionManager.thresholdVelocityForPositionChanges {
            newPosition = maxPosition
        } else if bottomBarCurrentPosition > maxPosition / 2 {
            newPosition = maxPosition
        } else {
            newPosition = -20
        }
        delegate?.bottomBarPositionShouldChange(to: newPosition, animated: true)
        isPanning = false
    }
    
    private func maxBottomBarPosition(in scrollView: UIScrollView) -> CGFloat {
        let bottomInset = scrollView.adjustedContentInset.bottom
        return bottomBarHeight + bottomInset
    }
    
    private func proposedBottomBarPosition(in scrollView: UIScrollView) -> CGFloat {
        let newContentOffset = scrollView.contentOffset.y
        return bottomBarCurrentPosition + contentOffset - newContentOffset
    }
    
}

//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, didUserSlingIt: Bool) {
//
//    }

//    private func calculateNewBarPosition(inside scrollView: UIScrollView) -> CGFloat {
//        let bottomInset = scrollView.adjustedContentInset.bottom
//        let maxValue = bottomBarHeight + bottomInset
//        let proposedNewPosition = bottomBarCurrentHeightInScrollView + previousOffset - scrollView.contentOffset.y
//
//        if scrollView.isTracking {
//            return min(max(proposedNewPosition, 0), maxValue)
//        } else {
//            return (maxValue / 2 < proposedNewPosition) ? maxValue : 0
//        }
//

//print("Scroll View is \(scrollView.isDragging ? "dragging" : "NOT DRAGGING")")
//        print()


//Take delta of previousOffset and currentOffset and set new height based on that

//TODO: Account for safe areas (nav bar too maybe)
//TODO: Handle someone who has stopped tracking (or stop scrolling rather?)
//decide when user is no longer dragging if it should be up or down


//        let topPosition = -scrollView.adjustedContentInset.top
//        let bottomPosition = scrollView.contentSize.height + scrollView.adjustedContentInset.bottom
//        let currentBottomOnScreen = scrollView.contentOffset.y + scrollView.frame.size.height
//        print("Top position: \(topPosition)")
//        print("Bottom position: \(bottomPosition)")
//        print("Previous position on screen: \(self.previousOffset)")
//        print("Current position on screen: \(scrollView.contentOffset.y)")
//        print("Current position on bottom of screen: \(currentBottomOnScreen)")



//            print("content offset changed to: \(offset.newValue!)")
//            print()
//            print("adjustedContentInset is: \(scrollView.adjustedContentInset)")
//            print("contentInset is: \(scrollView.contentInset)")
//            print("contentHeight is: \(scrollView.contentSize.height)")
//            print("bottom position (on screen) is: \(scrollView.contentOffset.y + scrollView.frame.size.height)")

//            print("\(scrollView.isDragging ? "isDragging" : "isNotDragging")") //dragging is moving
//            print("\(scrollView.isTracking ? "isTracking" : "isNotTracking")") //tracking is finger down
//            print()
//            print(scrollView)
//            print(offset)
//    @objc func test(scrollView: UIScrollView?) {
//        print("panGestureRecognized")
//        print()
//    }




//        token = scrollView.observe(\UIScrollView.contentOffset, options: .new) { [weak self] scrollView, _ in
//            guard let self = self else { return }
//
//            let newPosition = self.calculateNewBarPosition(inside: scrollView)
//            self.bottomBarCurrentHeightInScrollView = newPosition
//            self.delegate?.bottomBarPositionShouldChange(to: newPosition, animated: !scrollView.isTracking)
//
//            self.previousOffset = scrollView.contentOffset.y
//        }


//        let newContentOffset = scrollView.contentOffset.y
//        let bottomInset = scrollView.adjustedContentInset.bottom
//        let maxValue = bottomBarHeight + bottomInset

//        let proposedNewPosition = bottomBarCurrentPosition + contentOffset - newContentOffset



//        if scrollView.isTracking {
//
//        } else {
//            let newPosition = (maxValue / 2 < proposedNewPosition) ? maxValue : 0
//            delegate?.bottomBarPositionShouldChange(to: newPosition, animated: true)
//        }
