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
            return "Multiple object produce type \(value.type.typeName) for \(value.for.typeName)"
        case .missRegistration(let type, _):
            return "Object \(type) not registred in DIContainer."
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
            return "Inccorected path: \(path). --sourcePath can't direct to file, set directory instead"
        }
    }
}

struct ErrorCluster: LocalizedError {
    let errors: [Error]
    
    var localizedDescription: String {
        return errors.map { $0.localizedDescription }.joined(separator: "\n")
    }
}
