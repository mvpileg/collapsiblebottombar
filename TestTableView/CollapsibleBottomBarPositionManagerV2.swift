//
//  CollapsibleBottomBarPositionManagerV2.swift
//  TestTableView
//
//  Created by Matthew Pileggi on 3/3/20.
//  Copyright © 2020 Matthew Pileggi. All rights reserved.
//

import UIKit

class CollapsibleBottomBarPositionManagerV2 {
    
    private static let thresholdVelocityForPositionChanges: CGFloat = 0.5
    private static let animationDuration = 0.1
    
    enum BarState {
        case shown
        case transitioning
        case hidden
    }
    
    private var barState: BarState = .shown
                
    // MARK: Layout
    
    private var contentOffset: CGFloat = 0
    private var bottomInset: CGFloat = 0
    private let preferredHeight: CGFloat

    private let parentView: UIView
    private let safeAreaContainerView = UIView()
    
    private var expandedHeight: CGFloat {
        bottomInset + preferredHeight
    }
    
    private var currentPosition: CGFloat {
        -safeAreaContainerTopConstraint.constant
    }
    
    private lazy var safeAreaContainerHeightConstraint: NSLayoutConstraint = {
        safeAreaContainerView.heightAnchor.constraint(equalToConstant: preferredHeight)
    }()
    
    private lazy var safeAreaContainerTopConstraint: NSLayoutConstraint = {
        safeAreaContainerView.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -preferredHeight)
    }()
    
    // MARK: Init
    
    init(bottomBar: UIView, parentView: UIView, preferredHeight: CGFloat) {
        self.parentView = parentView
        self.preferredHeight = preferredHeight
        
        safeAreaContainerView.backgroundColor = bottomBar.backgroundColor
        
        setupLayout(with: bottomBar)
    }
    
    // MARK: ScrollView
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch barState {
        case .shown:
            barState = .transitioning
        case .hidden, .transitioning:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newContentOffset = scrollView.contentOffset.y
        let yDelta = contentOffset - newContentOffset
        
        switch barState {
        case .transitioning:
            adjustTrackingPosition(yDelta: yDelta)
        case .hidden, .shown:
            break
        }
        contentOffset = newContentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        if velocity.y < -CollapsibleBottomBarPositionManagerV2.thresholdVelocityForPositionChanges {
            barState = .shown
        } else if currentPosition == expandedHeight {
            barState = .shown
        } else {
            barState = .hidden
        }
        
        switch barState {
        case .shown:
            updateContainerPosition(to: expandedHeight, isAnimated: true)
        case .hidden:
            updateContainerPosition(to: 0, isAnimated: true)
        case .transitioning:
            break
        }
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        bottomInset = scrollView.adjustedContentInset.bottom
        safeAreaContainerHeightConstraint.constant = expandedHeight
        
        switch barState {
        case .shown:
            updateContainerPosition(to: expandedHeight, isAnimated: false)
        case .hidden, .transitioning:
            break
        }
    }
    
    // MARK: Private Helpers
    
    private func updateContainerPosition(to value: CGFloat, isAnimated: Bool) {
        safeAreaContainerTopConstraint.constant = -value
        
        if isAnimated {
            UIView.animate(withDuration: CollapsibleBottomBarPositionManagerV2.animationDuration) {
                self.parentView.layoutIfNeeded()
            }
        }
        parentView.layoutIfNeeded()
    }
    
    private func adjustTrackingPosition(yDelta: CGFloat) {
        let proposedPosition = currentPosition + yDelta
        let newPosition = min(max(proposedPosition, 0), expandedHeight)
        updateContainerPosition(to: newPosition, isAnimated: false)
    }
    
    private func setupLayout(with bottomBar: UIView) {
        parentView.addSubview(safeAreaContainerView)
        safeAreaContainerView.addSubview(bottomBar)
        
        safeAreaContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //container
            safeAreaContainerHeightConstraint,
            safeAreaContainerTopConstraint,
            safeAreaContainerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            safeAreaContainerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            //bottom bar
            bottomBar.leadingAnchor.constraint(equalTo: safeAreaContainerView.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: safeAreaContainerView.trailingAnchor),
            bottomBar.topAnchor.constraint(equalTo: safeAreaContainerView.topAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: preferredHeight)
        ])
    }

}
