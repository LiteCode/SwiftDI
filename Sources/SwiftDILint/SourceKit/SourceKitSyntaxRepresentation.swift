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

enum AccessibilityLevel: String, Codable {
    case `internal` = "source.lang.swift.accessibility.internal"
    case `public` = "source.lang.swift.accessibility.public"
    case `private` = "source.lang.swift.accessibility.private"
}

enum DIPartKind: String, Codable {
    case group
    case register
    case extendedPart
    case container
}

struct SourceKitDIContainerRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let fileName: String
    let line: Int
    let parent: String?
    let kind: DIPartKind = .container
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        self.fileName = fileName
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.parent = parent
    }
}

struct SourceKitDIGroupRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let fileName: String
    let line: Int
    let groupId: String
    let parent: String?
    let kind: DIPartKind = .group
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        self.fileName = fileName
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.groupId = "\(fileName)|\(line)|\(parent ?? "")_"
        self.parent = parent
    }
}

struct SourceKitCustomDIPartRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let name: String
    let line: Int
    let level: AccessibilityLevel
    let fileName: String
    let parent: String?
    let kind: DIPartKind = .extendedPart
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int, parent: String?) {
        
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else {
            return nil
        }
        
        guard let types = SwiftDocKey.getInheritedTypes(from: ast),
            types.contains(where: { (SwiftDocKey.getName(from: $0) == "DIPart") }) else { return nil }
        
        self.fileName = fileName
        self.line = line
        self.offset = Int(offset)
        self.length = Int(length)
        self.name = name
        self.level = AccessibilityLevel(rawValue: level) ?? .internal
        self.parent = parent
    }
}

struct SourceKitUndefinedDIPartRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let line: Int
    let name: String
    let fileName: String
    let parent: String?
    let kind: DIPartKind = .extendedPart
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int, parent: String?) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        
        self.offset = Int(offset)
        self.length = Int(length)
        self.fileName = fileName
        self.name = name
        self.parent = parent
        self.line = line
    }
}

struct SourceKitInjectedPropertyRepresentation: Token {
    let offset: Int
    let length: Int
    let name: String
    let level: AccessibilityLevel
    let fileName: String
    let line: Int
    let typeName: String
    let propertyWrapper: DIPropertyWrapper
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int) {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        guard let name = SwiftDocKey.getName(from: ast) else { return nil }
        guard let level = ast[SwiftDocKey.accessebility] as? String else { return nil }
        guard let attributes = ast[SwiftDocKey.attributes] as? [[String: SourceKitRepresentable]],
            let propertyWrapperAttribute = attributes.first(where: { ($0[SwiftDocKey.attribute] as? String) == SwiftDocValue.propertyWrapper.rawValue } ) else { return nil }
        guard let typeName = ast[SwiftDocKey.typeName.rawValue] as? String else { return nil }
        
        guard let propertyWrapper = Self.constainsDIPropertyWrapper(propertyWrapperAttribute, contents: file.contents) else { return nil }
        
        self.propertyWrapper = propertyWrapper
        self.line = line
        self.fileName = fileName
        self.offset = Int(offset)
        self.length = Int(length)
        self.name = name
        self.typeName = typeName
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

struct SourceKitDIRegisterRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let line: Int
    let objectType: String
    let additionalTypes: [String]
    let fileName: String
    let lifeTime: String?
    let parent: String?
    let kind: DIPartKind = .register
    
    init?(ast: [String: SourceKitRepresentable], fileName: String, file: File, line: Int, parent: String?) throws {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        let tokens = Self.parse(ast, contents: file.contents)
        
        guard !tokens.isEmpty else { return nil }
        
        var registerObject: String?
        var additionalTypes: [String] = []
        var lifeTime: String?
        
        for token in tokens {
            switch token {
            case .as(let objectType):
                additionalTypes.append(objectType)
            case .register(let object):
                registerObject = object
            case .lifeTime(let time):
                lifeTime = time
            }
        }
        
        guard let mainObject = registerObject else { return nil }
        
        self.line = line
        self.fileName = fileName
        self.offset = Int(offset)
        self.length = Int(length)
        self.objectType = mainObject
        self.additionalTypes = additionalTypes
        self.lifeTime = lifeTime
        self.parent = parent
    }
    
    enum Token {
        case register(String)
        case `as`(String)
        case lifeTime(String)
    }
    
    static func parse(_ ast: [String: SourceKitRepresentable], contents: String) -> [Token] {
        
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return [] }
        
        guard let length = SwiftDocKey.getLength(from: ast) else { return [] }
        
        let content = contents.bridge().substring(with: NSRange(location: Int(offset - 1), length: Int(length))).replacingOccurrences(of: " ", with: "")
        
        let elements = content.split(separator: Character("\n")).map(String.init).map { $0.trimmingCharacters(in: .whitespaces) }
        
        let regular = try! NSRegularExpression(pattern: "\\((.*?)\\)")
        
        var tokens: [Token] = []
        
        for element in elements {
            if element.hasPrefix("DIRegister") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: ".init", with: "")
                    tokens.append(.register(name))
                }
            } else if element.hasPrefix(".lifeCycle") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: ".", with: "")
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                    tokens.append(.lifeTime(name))
                }
            } else if element.hasPrefix(".as") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: ".self", with: "")
                    tokens.append(.as(name))
                }
            }
        }
        
        return tokens
    }
    
}

enum DIPropertyWrapper: String, Codable {
    case injected = "Injected"
    case environmentInjected = "EnvironmentInjected"
    case environmentBindableInjected = "EnvironmentBindableInjected"
}

protocol DIPartRepresentable {
    var parent: String? { get }
    var kind: DIPartKind { get }
}
