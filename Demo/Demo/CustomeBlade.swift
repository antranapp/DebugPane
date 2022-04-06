//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import TweakPane

public struct CustomBlade: Blade {
    public var name: String? = "Custom Blade"
    
    public init() {}
    
    public func render() -> AnyView {
        AnyView(ContentView())
    }
}

private struct ContentView: View {
    var body: some View {
        Button(
            action: {
                print("Button Pressed")
            },
            label: {
                Text("Press me")
            }
        )
    }
}

extension CustomBlade {
    static func setup() {
        print("setup me")
    }
}
