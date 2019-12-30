//
//  ErrorCluster.swift
//  
//
//  Created by Vladislav Prusakov on 30.12.2019.
//

import Foundation

struct ErrorCluster: LocalizedError {
    let errors: [XcodeError]
    let logLevel: XcodeLogLevel?
    
    var containsCriticalError: Bool {
        
        if let logLevel = logLevel {
            return logLevel == .error
        } else {
            return self.errors.contains(where: { $0.logLevel == .error })
        }
    }
    
    var errorDescription: String? {
        return errors.map {
            if let level = self.logLevel {
                return $0.description(for: level)
            } else {
                return $0.description
            }
        }.joined(separator: "\n")
    }
}
