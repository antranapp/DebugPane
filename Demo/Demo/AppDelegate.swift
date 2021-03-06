//
// Copyright © 2022 An Tran. All rights reserved.
//

import Combine
import DebugPane
import DebugPane_LocalConsole
import DebugPane_Pulse
import DebugPane_SwiftPublicIP
import Logging
import Pulse
import SwiftUI
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var bag = Set<AnyCancellable>()
    
    @ObservedObject private var appService = AppService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LoggingSystem.bootstrap(PersistentLogHandler.init)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(appService: appService)
        window?.makeKeyAndVisible()
    
        DebugPane.start(setup: [CustomBlade.setup]) {
            UIBlade {
                Button(
                    action: {
                        print("pressed")
                    },
                    label: {
                        Text("Custom UI Button")
                    }
                )
            }
            BuildInfoBlade()
            SwiftPublicIPBlade()
            InputBlade(name: "Dark Mode", binding: InputBinding(self.$appService.darkModeEnabled))
            LocalConsoleBlade()
            PulseBlade( presentingViewController: { self.window?.rootViewController?.topMostViewController() } )
            ChildViewBlade(navViewController: DebugPane.navController)
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
        
        LCManager.shared.print("App Started")

        return true
    }
}

final class AppService: ObservableObject {
    @Published var darkModeEnabled: Bool = true
}
