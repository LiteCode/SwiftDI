//
//  SourceKitInjectedPropertyRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitInjectedPropertyRepresentation: Token {
    let offset: Int
    let length: Int
    let name: String
    let level: AccessibilityLevel
    let filePath: String
    let line: Int
    let typeName: String
    let propertyWrapper: DIPropertyWrapper
    let parent: String
    let characters: NSRange?
    let underlineText: String?
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else { return nil }
        guard let attributes = ast[SwiftDocKey.attributes] as? [[String: SourceKitRepresentable]],
            let propertyWrapperAttribute = attributes.first(where: { ($0[SwiftDocKey.attribute] as? String) == SwiftDocValue.propertyWrapper.rawValue } ) else { return nil }
        guard let typeName = ast[SwiftDocKey.typeName.rawValue] as? String else { return nil }
        
        guard let propertyWrapper = Self.constainsDIPropertyWrapper(propertyWrapperAttribute, contents: file.contents) else { return nil }
        
        let content = file.lines[safe: line - 1]?.content.bridge()
        self.characters = content?.range(of: typeName)
        self.underlineText = content?.bridge()
        self.propertyWrapper = propertyWrapper
        self.line = line
        self.filePath = filePath
        self.offset = Int(offset)
        self.length = Int(length)
        self.name = name
        self.typeName = typeName
        self.parent = parent
        self.level = AccessibilityLevel(rawValue: level) ?? .internal
    }
    
    static func constainsDIPropertyWrapper(_ ast: [String: SourceKitRepresentable], contents: String) -> DIPropertyWrapper? {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        let propertyWrapper = contents.bridge().substring(with: NSRange(location: Int(offset), length: Int(length))).trimmingCharacters(in: .whitespacesAndNewlines)
        
        return DIPropertyWrapper(rawValue: propertyWrapper)
    }
    
    static let supportedPropertyWrappers = ["Injected", "EnvironmentInjected", "EnvironmentBindableInjected"]
}
