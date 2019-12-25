//
//  SwiftDocKey+Extensions.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

extension SwiftDocKey {
    static func getName(from ast: [String : SourceKitRepresentable]) -> String? {
        return ast[SwiftDocKey.name.rawValue] as? String
    }
    
    static func getSubstructure(from ast: [String : SourceKitRepresentable]) -> [[String : SourceKitRepresentable]]? {
        return ast[SwiftDocKey.substructure.rawValue] as? [[String : SourceKitRepresentable]]
    }
    
    static func getKind(from ast: [String : SourceKitRepresentable]) -> String? {
        return ast[SwiftDocKey.kind.rawValue] as? String
    }
    
    static func getOffset(from ast: [String : SourceKitRepresentable]) -> Int64? {
        return ast[SwiftDocKey.offset.rawValue] as? Int64
    }
    
    static func getLength(from ast: [String : SourceKitRepresentable]) -> Int64? {
        return ast[SwiftDocKey.length.rawValue] as? Int64
    }
    
    static func getInheritedTypes(from ast: [String : SourceKitRepresentable]) -> [[String : SourceKitRepresentable]]? {
        return ast[SwiftDocKey.inheritedtypes.rawValue] as? [[String: SourceKitRepresentable]]
    }
}
