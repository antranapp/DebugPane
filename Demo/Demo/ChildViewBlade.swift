//
//  ChildViewBlade.swift
//  Demo
//
//  Created by An Tran on 11/4/22.
//

import Foundation
import SwiftUI
import DebugPane

public struct ChildViewBlade: Blade {
    public var name: String? = "Child View"
    
    private var navViewController: () -> UINavigationController?
    
    public init(navViewController: @autoclosure @escaping () -> UINavigationController?) {
        self.navViewController = navViewController
    }
    
    public func render() -> AnyView {
        AnyView(ContentView(action: { navViewController()?.pushViewController($0, animated: true) }))
    }
}

private struct ContentView: View {
    var action: (UIViewController) -> Void
    var body: some View {
        VStack {
            Button(
                action: {
                    action(UIHostingController(rootView: ChildContentView()))
                },
                label: {
                    Text("Show Child View")
                }
            )
        }
    }
}

private struct ChildContentView: View {
    var body: some View {
        Text("Child View")
    }
}
