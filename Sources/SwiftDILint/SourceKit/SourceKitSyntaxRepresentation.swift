//
//  SourceKitSyntaxRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import SourceKittenFramework
import Foundation

extension SwiftDocKey {
    /// Return access level for entity (String)
    static let accessebility = "key.accessibility"
    
    /// Return array of attributes ([[String : SourceKitRepresentable]])
    ///
    /// - Parameter `key.attribute` - information about attribute (accessability/propertyWrapper)
    /// - Parameter `key.length` - attribute length
    /// - Parameter `key.offset` - attribute offset
    static let attributes = "key.attributes"
    
    static let attribute = "key.attribute"
}

private enum SwiftDocValue: String {
    case propertyWrapper = "source.decl.attribute._custom"
    case objc = "source.decl.attribute.objc"
    case argument = "source.lang.swift.expr.argument"
}

enum AccessibilityLevel: String {
    case `internal` = "source.lang.swift.accessibility.internal"
    case `public` = "source.lang.swift.accessibility.public"
    case `private` = "source.lang.swift.accessibility.private"
}

enum DIPartKind {
    case group
    case register
    case extendedPart
}

struct SourceKitDIPartRepresentation {
    let offset: Int
    let lenght: Int
    let name: String
    let level: AccessibilityLevel
    let fileName: String
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File) throws {
        
        guard let offset = ast[SwiftDocKey.offset.rawValue] as? Int64 else { return nil }
        
        guard let lenght = ast[SwiftDocKey.length.rawValue] as? Int64 else { return nil }
        
        guard let name = ast[SwiftDocKey.name.rawValue] as? String else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else {
            return nil
        }
        
        guard let types = ast[SwiftDocKey.inheritedtypes.rawValue] as? [[String: Any]],
        types.contains(where: { ($0[SwiftDocKey.name.rawValue] as? String) == "DIPart" }) else { return nil }
        
        
        self.fileName = fileName
        self.offset = Int(offset)
        self.lenght = Int(lenght)
        self.name = name
        self.level = AccessibilityLevel(rawValue: level) ?? .internal
    }
}

struct SourceKitParamRepresentation {
    let offset: Int
    let lenght: Int
    let name: String
    let level: AccessibilityLevel
    let fileName: String
    let propertyWrapper: DIPropertyWrapper
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File) throws {
        guard let offset = ast[SwiftDocKey.offset.rawValue] as? Int64 else { return nil }
        
        guard let lenght = ast[SwiftDocKey.length.rawValue] as? Int64 else { return nil }
        
        guard let name = ast[SwiftDocKey.name.rawValue] as? String else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else { return nil }
        guard let attributes = ast[SwiftDocKey.attributes] as? [[String: SourceKitRepresentable]],
            let propertyWrapperAttribute = attributes.first(where: { ($0[SwiftDocKey.attribute] as? String) == SwiftDocValue.propertyWrapper.rawValue } ) else { return nil }
        
        
        guard let propertyWrapper = Self.constainsDIPropertyWrapper(propertyWrapperAttribute, contents: file.contents) else { return nil }
        
        self.propertyWrapper = propertyWrapper
        self.fileName = fileName
        self.offset = Int(offset)
        self.lenght = Int(lenght)
        self.name = name
        self.level = AccessibilityLevel(rawValue: level) ?? .internal
    }
    
    static func constainsDIPropertyWrapper(_ ast: [String: SourceKitRepresentable], contents: String) -> DIPropertyWrapper? {
        
        guard let offset = ast[SwiftDocKey.offset.rawValue] as? Int64 else { return nil }
        
        guard let lenght = ast[SwiftDocKey.length.rawValue] as? Int64 else { return nil }
        
        let propertyWrapper = contents.bridge().substring(with: NSRange(location: Int(offset), length: Int(lenght))).trimmingCharacters(in: .whitespacesAndNewlines)
        
        return DIPropertyWrapper(rawValue: propertyWrapper)
    }
    
    static let supportedPropertyWrappers = ["Injected", "EnvironmentInjected", ""]
}

enum DIPropertyWrapper: String {
    case injected = "Injected"
    case environmentInjected = "EnvironmentInjected"
    case environmentBindableInjected = "EnvironmentBindableInjected"
}
