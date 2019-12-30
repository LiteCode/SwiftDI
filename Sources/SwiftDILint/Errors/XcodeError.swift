//
//  XcodeError.swift
//  
//
//  Created by Vladislav Prusakov on 30.12.2019.
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

    /// Error for xcode
    /// Template: {full_path_to_file}{:line}{:character}: {error,warning}: {content}
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
