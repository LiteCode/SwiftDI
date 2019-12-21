//
//  Errors.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

protocol XcodeError: Error, CustomStringConvertible {
    var location: FileLocation? { get }
    var logLevel: XcodeLogLevel { get }
    var message: String { get }
}

extension XcodeError {
    var description: String {
        switch (self.location?.line, location?.file) {
        case (.some(let line), .some(let file)):
            return "\(file):\(line + 1): \(logLevel.rawValue): \(message)."
        case (nil, .some(let file)):
            return "\(file):1: \(logLevel.rawValue): \(message)."
        case (_, nil):
            return "\(logLevel.rawValue): \(message)."
        }
    }
}

enum XcodeLogLevel: String {
    case error, warning
}


enum DIError: XcodeError {
    
    case multipleProduce(type: ObjectType, for: ObjectType, location: FileLocation)
    
    var location: FileLocation? {
        switch self {
        case .multipleProduce(let value):
            return value.location
        }
    }
    
    var message: String {
        switch self {
        case .multipleProduce(let value):
            return "Multiple object produce type \(value.type.name) for \(value.for.name)"
        }
    }
    
    var logLevel: XcodeLogLevel {
        switch self {
        case .multipleProduce:
            return .error
        }
    }
}
