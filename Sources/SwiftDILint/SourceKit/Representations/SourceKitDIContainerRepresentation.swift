//
//  SourceKitDIContainerRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitDIContainerRepresentation: Token, DIPartRepresentable {
    let id: String
    let offset: Int
    let length: Int
    let filePath: String
    let line: Int
    let parent: String?
    let kind: DIPartKind = .container
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        self.id = UUID().uuidString
        self.filePath = filePath
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.parent = parent
    }
}
