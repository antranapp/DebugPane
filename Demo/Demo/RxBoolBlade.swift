//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation
import SwiftUI
import TweakPane
import RxCocoa
import Combine

public struct RxBoolBlade: Blade {
    public var name: String = "Rx Bool Blade"
    
    private var property: BehaviorRelay<Bool>
    
    public init(property: BehaviorRelay<Bool>) {
        self.property = property
    }
    
    public func render() -> AnyView {
        AnyView(ContentView(property: property))
    }
}

private struct ContentView: View {
    
    @StateObject var viewModel: ViewModel

    public init(property: BehaviorRelay<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(rxProperty: property))
    }

    var body: some View {
        Toggle(isOn: $viewModel.boolValue) {
            Text("Toggle")
        }
    }
}

extension ContentView {
    final class ViewModel: ObservableObject {
        
        private var bag = Set<AnyCancellable>()
        private var rxProperty: BehaviorRelay<Bool>
        
        @Published var boolValue: Bool = false
        
        init(rxProperty: BehaviorRelay<Bool>) {
            self.rxProperty = rxProperty
            
            $boolValue.sink { value in
                rxProperty.accept(value)
            }
            .store(in: &bag)
        }
    }
}
