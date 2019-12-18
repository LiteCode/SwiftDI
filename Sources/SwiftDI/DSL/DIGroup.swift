//
//  DIGroup.swift
//  Pods-SwiftDIDemo
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

public struct DIGroup<Part: DIPart>: DIPart {
    
    public var body: some DIPart {
        objects
    }
    
    let objects: Part
    
    public init(@DIBuilder objects: () -> Part) {
        self.objects = objects()
    }
}
