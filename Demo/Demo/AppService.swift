//
//  AppService.swift
//  Demo
//
//  Created by An Tran on 23/3/22.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

final class AppService: ObservableObject {
    @Published var darkModeEnabled: Bool = true
    var boolValue = BehaviorRelay<Bool>(value: false)    
}
