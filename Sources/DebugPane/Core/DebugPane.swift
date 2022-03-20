//
// Copyright © 2022 An Tran. All rights reserved.
//

import SwiftUI
@_exported import TweakPane
import UIKit

public final class DebugPane: NSObject {

    public enum GestureType: UInt {
        case tripleTap, panFromRight
    }

    static var window: DebugPaneWindow!
    
    static var navController: UINavigationController!
    static var viewController: UIViewController!
    static let drawerWidth: CGFloat = UIScreen.main.bounds.width * 3 / 4
    private static let startOnce = DispatchOnce()
    
    public static func start(
        with gesture: GestureType = .panFromRight,
        @BladesBuilder _ content: @escaping () -> [Blade]
    ) {
        startOnce.perform {
            initializeWindow(content)
            setGestureType(gesture)
        }
    }
    
    public static func setGestureType(_ type: GestureType, _ threshold: CGFloat = 50.0) {
        configureRecognizerForType(type, threshold)
    }
    
    // Navigation
    public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navController.pushViewController(viewController, animated: animated)
    }
    
    public static func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navController.present(viewController, animated: animated, completion: completion)
    }
    
    // Internal Accessors
    static func loadKeyWindow() -> UIWindow? {
        var window = UIApplication.shared.windows.filter(\.isKeyWindow).first
        
        if window == nil {
            window = UIApplication.shared.keyWindow
        }
        
        return window
    }
    
    static func loadActiveResponder() -> UIViewController? {
        return loadKeyWindow()?.rootViewController
    }
    
}

// Visibility
public extension DebugPane {
    
    // Technically this could be wrong depending on the tx value, but it is close enough.
    static var isVisible: Bool { return !(navController.view.transform == CGAffineTransform.identity) }
    
    static func openDebugPane(completion: (() -> Void)? = nil) {
        window.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
            window.setActivationPercent(1)
        }) { completed in
            // Swap gestures
            openRecognizer.view?.removeGestureRecognizer(openRecognizer)
            window.addGestureRecognizer(dismissalRecognizer)
            
            completion?()
        }
    }
    
    static func closeDebugPane(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform.identity
            window.setActivationPercent(0)
        }) { completed in
            window.isHidden = true
            
            // Swap gestures
            dismissalRecognizer.view?.removeGestureRecognizer(dismissalRecognizer)
            replaceGestureRecognizer(with: openRecognizer)
            
            completion?()
        }
    }
    
    internal static func toggleVisibility(completion: (() -> Void)? = nil) {
        if isVisible {
            closeDebugPane(completion: completion)
        } else {
            openDebugPane(completion: completion)
        }
    }
    
}

// Backwards compatibility
public extension DebugPane {
    
    static func dismissWindow() {
        closeDebugPane(completion: nil)
    }
    
}
