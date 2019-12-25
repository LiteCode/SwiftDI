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
        switch (self.location?.line, location?.file, location?.characters) {
        case (.some(let line), .some(let file), .some(let characters)):
            return "\(file):\(line):\(characters.location + 1): \(logLevel.rawValue): \(message)"
        case (.some(let line), .some(let file), nil):
            return "\(file):\(line): \(logLevel.rawValue): \(message)"
        case (nil, .some(let file), _):
            return "\(file):1: \(logLevel.rawValue): \(message)"
        case (_, nil,  _):
            return "\(logLevel.rawValue): \(message)"
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
            return "Multiple object produce type '\(value.type.typeName)' for '\(value.for.typeName)'."
        case .missRegistration(let type, let location):
            let message = "Object '\(type.typeName)' not registred in DIContainer\n"
            return self.underlineErrorIfNeeded(for: message, at: location)
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
    
    private func underlineErrorIfNeeded(for message: String, at location: FileLocation) -> String {
        var message = message
        if let errorRange = location.characters, let underlineText = location.underlineText {
            message += underlineText + "\n"
            message += String(repeating: " ", count: max(errorRange.location, 0)) + "^" + String(repeating: "~", count: errorRange.length - 1) + "\n"
            message += String(repeating: " ", count: max(errorRange.location, 0)) + "_"
        }
        return message
        
    }
}


enum CommandError: LocalizedError {
    
    case invalidSourcePath(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidSourcePath(let path):
            return "Incorrected path: \(path). Path can't direct to file, set directory instead"
        }
    }
}

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
