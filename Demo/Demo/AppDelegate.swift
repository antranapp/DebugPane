//
// Copyright © 2022 An Tran. All rights reserved.
//

import DebugPane
import SwiftUI
import Combine
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var bag = Set<AnyCancellable>()
    
    @ObservedObject private var appService = AppService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(appService: appService)
        window?.makeKeyAndVisible()
    
        DebugPane.start {
            InputBlade(name: "Dark Mode", binding: InputBinding(self.$appService.darkModeEnabled))
        }
        
        appService.$darkModeEnabled
            .sink { [weak self] value in
                if value {
                    self?.window?.overrideUserInterfaceStyle = .dark
                } else {
                    self?.window?.overrideUserInterfaceStyle = .light
                }
            }
            .store(in: &bag)
        
        return true
    }
}

final class AppService: ObservableObject {
    @Published var darkModeEnabled: Bool = true
}
