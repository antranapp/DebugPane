//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

internal extension DebugPane {
    
    // State
    static var openRecognizer: UIGestureRecognizer!
    static var dismissalRecognizer: UISwipeGestureRecognizer!
    
    static var threshold: CGFloat!
    private static let gestureDelegate = GestureDelegate()
    
    // Setup
    static func configureRecognizerForType(_ type: GestureType, _ threshold: CGFloat) {
        self.threshold = threshold
        
        // Setup show gesture
        switch type {
        case .tripleTap:
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap(sender:)))
            recognizer.numberOfTapsRequired = 3
            recognizer.delegate = gestureDelegate
            replaceGestureRecognizer(with: recognizer)
        case .panFromRight:
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
            recognizer.delegate = gestureDelegate
            replaceGestureRecognizer(with: recognizer)
        }
        
        // Setup dismiss gesture
        if let old = dismissalRecognizer { old.view?.removeGestureRecognizer(old) }
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissalRecognizerEvent))
        dismissalRecognizer.direction = .right
        dismissalRecognizer.delegate = gestureDelegate
    }
    
    // Handlers
    @objc private static func handleTripleTap(sender: UITapGestureRecognizer?) {
        guard let _ = sender else { print("Missing sender."); return }
        toggleVisibility()
    }
    
    @objc private static func handlePan(sender: UIPanGestureRecognizer?) {
        guard let sender = sender else { print("Missing sender."); return }
        
        switch sender.state {
        case .began:
            // Make sure they started on the far edge
            let distanceFromEdge = sender.view!.bounds.width - sender.location(in: sender.view).x
            guard distanceFromEdge < threshold else { sender.isEnabled = false; break }
            guard beginDebugPaneVisibilityUpdate() else { sender.isEnabled = false; break }
        case .changed:
            let limitedPan = max(sender.translation(in: sender.view).x, -navController.view.frame.width)
            navController.view.transform = CGAffineTransform(translationX: limitedPan, y: 0)
            let percent = abs(limitedPan) / drawerWidth
            window.setActivationPercent(percent)
        default:
            sender.isEnabled = true
            
            // Gesture finished; now we must determine what the final state is.
            if abs(navController.view.transform.tx) >= (navController.view.frame.size.width / 2) {
                openDebugPane()
            } else {
                closeDebugPane()
            }
        }
    }
    
    // Visibility Updates
    private static func beginDebugPaneVisibilityUpdate() -> Bool {
        // Ensure the window is visible
        let appWindow = loadKeyWindow()
        window.makeKeyAndVisible()
        window.addSubview(navController.view)
        appWindow?.makeKeyAndVisible()
        
        return true
    }
    
    // Convenience
    static func replaceGestureRecognizer(with recognizer: UIGestureRecognizer) {
        // Remove old (if applicable)
        if let gestureRecognizer = openRecognizer {
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        }
        
        // Add new
        openRecognizer = recognizer
        loadKeyWindow()?.addGestureRecognizer(openRecognizer)
    }
    
    @objc private static func dismissalRecognizerEvent() { closeDebugPane() } // We can't call closeDebugPane from the selector because of the optional completion block
    
}

// Gesture Delegates
private class GestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == DebugPane.openRecognizer {
            
        } else if gestureRecognizer == DebugPane.dismissalRecognizer {
            if touch.view is UISlider { return false } // Prevent pan from interfering with slider
        }
        
        return true
    }
    
}
