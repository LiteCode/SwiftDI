//
//  Never.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

extension Never: DIPart {
    public var body: Never {
        fatalError()
    }
}
