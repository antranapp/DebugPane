//
// Copyright © 2022 An Tran. All rights reserved.
//

import Foundation

@objc public class DispatchOnce: NSObject {
    
    private var locked = false
        
    @objc public func perform(_ block: () -> Void) {
        if !locked {
            locked = true
            block()
        }
    }
}
