//
//  Extensions.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation

extension NSRecursiveLock {
    @discardableResult
    func sync<T>(_ block: () -> T) -> T {
        self.lock()
        defer { self.unlock() }
        return block()
    }
}
