//
//  SourceKitDIGroupRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitDIGroupRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let filePath: String
    let line: Int
    let groupId: String
    let parent: String?
    let kind: DIPartKind = .group
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        self.filePath = filePath
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.groupId = UUID().uuidString
        self.parent = parent
    }
}
