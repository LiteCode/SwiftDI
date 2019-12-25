//
//  SourceKitCustomDIPartRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitCustomDIPartRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let name: String
    let line: Int
    let level: AccessibilityLevel
    let filePath: String
    let parent: String?
    let kind: DIPartKind = .extendedPart
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String?) {
        
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else {
            return nil
        }
        
        guard let types = SwiftDocKey.getInheritedTypes(from: ast),
            types.contains(where: { (SwiftDocKey.getName(from: $0) == "DIPart") }) else { return nil }
        
        self.filePath = filePath
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.name = name
        self.level = AccessibilityLevel(rawValue: level) ?? .internal
        self.parent = parent
    }
}
