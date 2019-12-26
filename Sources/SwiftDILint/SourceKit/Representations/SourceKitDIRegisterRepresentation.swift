//
//  SourceKitDIRegisterRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation
import SourceKittenFramework

struct SourceKitDIRegisterRepresentation: Token, DIPartRepresentable {
    let offset: Int
    let length: Int
    let line: Int
    let objectType: String
    let additionalTypes: [String]
    let filePath: String
    let lifeTime: String?
    let parent: String?
    let kind: DIPartKind = .register
    let characters: NSRange?
    let underlineText: String?
    
    init?(ast: [String: SourceKitRepresentable], filePath: String, file: File, line: Int, parent: String?) throws {
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
        
        let content = file.lines[safe: line - 1]?.content.bridge()
        self.characters = content?.range(of: mainObject)
        self.underlineText = content?.bridge()
        self.line = line
        self.filePath = filePath
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
        
        guard let range = Range<String.Index>(NSRange(location: Int(offset - 1), length: Int(length)), in: contents) else { return [] }
        let content = contents[range].replacingOccurrences(of: " ", with: "")
        
        let elements = content.split(separator: Character("\n")).map(String.init).map { $0.trimmingCharacters(in: .whitespaces) }
        
        let regular = try! NSRegularExpression(pattern: "\\((.*?)\\)")
        
        var tokens: [Token] = []
        
        for element in elements {
            
            // TODO: SwiftDILint doesn't recognize nested object when using clouser instead of autoclouser
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
