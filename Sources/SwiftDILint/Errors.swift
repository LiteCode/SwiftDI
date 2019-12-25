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
        self.description(for: self.logLevel)
    }
    
    func description(for logLevel: XcodeLogLevel) -> String {
        switch (self.location?.line, location?.file, location?.character) {
        case (.some(let line), .some(let file), .some(let character)):
            return "\(file):\(line):\(character + 1): \(logLevel.rawValue): \(message)."
        case (.some(let line), .some(let file), nil):
            return "\(file):\(line): \(logLevel.rawValue): \(message)."
        case (nil, .some(let file), _):
            return "\(file):1: \(logLevel.rawValue): \(message)."
        case (_, nil,  _):
            return "\(logLevel.rawValue): \(message)."
        }
    }
}

enum XcodeLogLevel: String {
    case error, warning
}

enum DIError: XcodeError {
    
    case multipleProduce(type: ObjectType, for: ObjectType, location: FileLocation)
    case missRegistration(type: ObjectType, location: FileLocation)
    
    var location: FileLocation? {
        switch self {
        case .multipleProduce(let value):
            return value.location
        case .missRegistration(let value):
            return value.location
        }
    }
    
    var message: String {
        switch self {
        case .multipleProduce(let value):
            return "Multiple object produce type '\(value.type.typeName)' for '\(value.for.typeName)'"
        case .missRegistration(let type, _):
            return "Object '\(type.typeName)' not registred in DIContainer"
        }
    }
    
    var logLevel: XcodeLogLevel {
        switch self {
        case .multipleProduce:
            return .error
        case .missRegistration:
            return .warning
        }
    }
}


enum CommandError: LocalizedError {
    
    case invalidSourcePath(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidSourcePath(let path):
            return "Inccorected path: \(path). Path can't direct to file, set directory instead"
        }
    }
}

struct ErrorCluster: LocalizedError {
    let errors: [XcodeError]
    let logLevel: XcodeLogLevel?
    
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
