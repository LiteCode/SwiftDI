//
//  DIError.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

enum DIError: XcodeError {
    
    case multipleProduce(type: ObjectType, for: ObjectType, location: FileLocation)
    case missRegistration(type: ObjectType, location: FileLocation)
    case unusedRegistration(type: ObjectType, location: FileLocation)
    case containerNotFound
    
    var location: FileLocation? {
        switch self {
        case .multipleProduce(let value):
            return value.location
        case .missRegistration(let value):
            return value.location
        case .unusedRegistration(let value):
            return value.location
        default:
            return nil
        }
    }
    
    var message: String {
        switch self {
        case .multipleProduce(let value):
            return "Multiple object produce type '\(value.type.typeName)' for '\(value.for.typeName)'."
        case .missRegistration(let type, let location):
            let message = "Object '\(type.typeName)' not registred in DIContainer"
            return self.underlineErrorIfNeeded(for: message, at: location)
        case .unusedRegistration(let type, let location):
            let message = "Registred object '\(type.typeName)' is unused in project"
            return self.underlineErrorIfNeeded(for: message, at: location)
        case .containerNotFound:
            return "Can't find DIContainer in your project"
        }
    }
    
    var logLevel: XcodeLogLevel {
        switch self {
        case .multipleProduce:
            return .error
        case .missRegistration:
            return .warning
        case .unusedRegistration:
            return .warning
        case .containerNotFound:
            return .error
        }
    }
    
    private func underlineErrorIfNeeded(for message: String, at location: FileLocation) -> String {
        var message = message
        if let errorRange = location.characters, let underlineText = location.underlineText {
            message += "\n" + underlineText + "\n"
            message += String(repeating: " ", count: max(errorRange.location, 0)) + "^" + String(repeating: "~", count: errorRange.length - 1) + "\n"
            message += String(repeating: " ", count: max(errorRange.location, 0)) + "_"
        }
        return message
        
    }
}
