//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import TweakPane

public struct BuildInfoBlade: Blade {
    public var name: String? = "Build Info"
    
    public init() {}
    
    public func render() -> AnyView {
        AnyView(BuildInfoView())
    }
}

private struct BuildInfoView: View {
    private let info = Bundle.main.infoDictionary

    var body: some View {
        VStack(alignment: .leading) {
            Text(info?["CFBundleName"] as? String ?? "unknown")
            Text((info?["CFBundleDisplayName"] as? String ?? info?["CFBundleName"] as? String) ?? "unknown")
            Text(info?["CFBundleShortVersionString"] as? String ?? "unknown")
            Text(info?["CFBundleVersion"] as? String ?? "unknown")
            Text(info?["CFBundleIdentifier"] as? String ?? "unknown")
        }
    }
}
