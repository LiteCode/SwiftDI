//
//  CommandError.swift
//  
//
//  Created by Vladislav Prusakov on 30.12.2019.
//

import Foundation

enum CommandError: LocalizedError {
    
    case invalidSourcePath(String)
    case unsupportedOSX(minimal: String)
    case nonWrittablePath(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidSourcePath(let path):
            return "Incorrected path: \(path). Path can't direct to file, set directory instead"
        case .unsupportedOSX(let version):
            return "Unsupported macOS version, require \(version) or higher."
        case .nonWrittablePath(let path):
            return "Can't write file by path \(path). Path is non writtable."
        }
    }
}
