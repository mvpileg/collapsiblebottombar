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
    
    enum BarPosition {
        case show
        case transition
        case hide
    }
    
    private static let thresholdVelocityForPositionChanges: CGFloat = 0.5

    private let bottomBarHeight: CGFloat
    private var contentOffset: CGFloat
    private var bottomBarCurrentPosition: CGFloat
    private var barPosition = BarPosition.show
    
    private weak var delegate: CollapsibleBottomBarPositionDelegate?


    
    init(bottomBarHeight: CGFloat, scrollView: UIScrollView, delegate: CollapsibleBottomBarPositionDelegate) {
        self.bottomBarHeight = bottomBarHeight
        bottomBarCurrentPosition = bottomBarHeight
        contentOffset = scrollView.contentOffset.y
        self.delegate = delegate
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch barPosition{
        case .transition:
            adjustBarForUserDrag(scrollView)
        case .hide, .show:
            break
        }
        contentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // We only move into the transition state from the show state here
        // This prevents the bar from peeking out unnecessarily after being hidden
        // User can still get bar to show again in scrollViewWillEndDragging
        if barPosition == .show {
            barPosition = .transition
        }
    }
    
    /**
     Call this when user removes finger from screen (easiest from UIScrollViewDelegate.scrollViewWillEndDragging
     If scrolling up fast, show the bottom bar
     If scrolling down fast, hide the bottom bar
     If somewhere inbetween, let the bar move to whichever position is closer
     */
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        let yVelocity = velocity.y
        let maxPosition = maxBottomBarPosition(in: scrollView)
        
        if yVelocity < -CollapsibleBottomBarPositionManager.thresholdVelocityForPositionChanges {
            barPosition = .show
        } else if yVelocity > CollapsibleBottomBarPositionManager.thresholdVelocityForPositionChanges {
            barPosition = .hide
        } else if bottomBarCurrentPosition > maxPosition * 0.5 {
            barPosition = .show
        } else {
            barPosition = .hide
        }
        
        let newPosition: CGFloat
        switch barPosition {
        case .hide:
            newPosition = 0
        case .show:
            newPosition = maxPosition
        case .transition:
            return
        }
        bottomBarCurrentPosition = newPosition
        delegate?.bottomBarPositionShouldChange(to: newPosition, animated: true)
    }
    
    private func adjustBarForUserDrag(_ scrollView: UIScrollView) {
        let maxPosition = maxBottomBarPosition(in: scrollView)
        let proposedPosition = proposedBottomBarPosition(in: scrollView)
        
        let newPosition = min(max(proposedPosition, -20), maxPosition)
        bottomBarCurrentPosition = newPosition
        delegate?.bottomBarPositionShouldChange(to: newPosition, animated: false)
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
