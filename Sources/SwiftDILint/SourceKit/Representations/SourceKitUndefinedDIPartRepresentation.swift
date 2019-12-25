//
//  SourceKitUndefinedDIPartRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitUndefinedDIPartRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let line: Int
    let name: String
    let filePath: String
    let parent: String?
    let kind: DIPartKind = .extendedPart
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        
        self.offset = Int(offset)
        self.length = Int(length)
        self.filePath = filePath
        self.name = name
        self.parent = parent
        self.line = line
    }
}
