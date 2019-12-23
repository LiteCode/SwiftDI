//
//  Lexer.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import SourceKittenFramework
import PathKit
import Foundation

enum SourceKitKind: String {
    case `class` = "source.lang.swift.decl.class"
    case `struct` = "source.lang.swift.decl.struct"
    case `enum` = "source.lang.swift.decl.enum"
    case call = "source.lang.swift.expr.call"
    /// `var.class`.
    case varClass = "source.lang.swift.decl.var.class"
    /// `var.global`.
    case varGlobal = "source.lang.swift.decl.var.global"
    /// `var.instance`.
    case varInstance = "source.lang.swift.decl.var.instance"
    /// `var.local`.
    case varLocal = "source.lang.swift.decl.var.local"
    /// `var.parameter`.
    case varParameter = "source.lang.swift.decl.var.parameter"
    /// `var.static`.
    case varStatic = "source.lang.swift.decl.var.static"
}

class Lexer {
    
    let file: File
    let fileName: String
    
    init(file: File, fileName: String) {
        self.file = file
        self.fileName = fileName
    }
    
    func tokens() throws -> [Token] {
        
        let ast = try Structure(file: file).dictionary
        
        var line = self.file.lines.startIndex
        let tokens = try tokenizeAST(ast, line: &line, parent: nil)
        return tokens
    }
    
    func tokenizeAST(_ ast: [String : SourceKitRepresentable], line: inout Int, parent: String?) throws -> [Token] {
        var tokens = [Token]()
        
        if let kindString = SwiftDocKey.getKind(from: ast), let kind = SourceKitKind(rawValue: kindString) {
            switch kind {
            case .class, .struct, .enum:
                if let customPart = SourceKitCustomDIPartRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line, parent: parent) {
                    tokens.append(customPart)
                    
                    if let children = SwiftDocKey.getSubstructure(from: ast) {
                        for child in children {
                            line = self.line(for: child) ?? line
                            tokens += try tokenizeAST(child, line: &line, parent: customPart.name)
                        }
                        
                        return tokens
                    }
                }
            case .varClass, .varLocal, .varInstance, .varParameter, .varGlobal, .varStatic:
                if let propertyWrapper = SourceKitInjectedPropertyRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line) {
                    tokens.append(propertyWrapper)
                }
            case .call:
                if let groupTokens = try tokenizeDIGroup(ast, line: &line, parent: parent) {
                    tokens += groupTokens
                    return tokens
                } else if let containerTokens = try tokenizeDIContainer(ast, line: &line, parent: parent) {
                    tokens += containerTokens
                    return tokens
                } else if let register = try SourceKitDIRegisterRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line, parent: parent) {
                    tokens.append(register)
                    return tokens
                } else if let undefinedDIPart = SourceKitUndefinedDIPartRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line, parent: parent), parent != nil {
                    tokens.append(undefinedDIPart)
                }
            }
        }
        
        if let children = SwiftDocKey.getSubstructure(from: ast) {
            for child in children {
                line = self.line(for: child) ?? line
                tokens += try tokenizeAST(child, line: &line, parent: parent)
            }
        }
        
        return tokens
    }
    
    private func tokenizeDIContainer(_ ast: [String : SourceKitRepresentable], line: inout Int, parent: String?) throws -> [Token]? {
        guard let name = SwiftDocKey.getName(from: ast), name == "DIContainer",
            let container = SourceKitDIContainerRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line, parent: parent),
            let closure = SwiftDocKey.getSubstructure(from: ast)?.first else { return nil }
        var tokens: [Token] = []
        tokens.append(container)
        line = self.line(for: closure) ?? line
        tokens += try tokenizeAST(closure, line: &line, parent: parent)
        return tokens
    }
    
    private func tokenizeDIGroup(_ ast: [String : SourceKitRepresentable], line: inout Int, parent: String?) throws -> [Token]? {
        guard let name = SwiftDocKey.getName(from: ast), name == "DIGroup",
        let group = SourceKitDIGroupRepresentation(ast: ast, fileName: self.fileName, file: self.file, line: line, parent: parent),
            let closure = SwiftDocKey.getSubstructure(from: ast)?.first else { return nil }
        var tokens: [Token] = []
        tokens.append(group)
        line = self.line(for: closure) ?? line
        tokens += try tokenizeAST(closure, line: &line, parent: group.groupId)
        return tokens
    }
    
    private func line(for ast: [String : SourceKitRepresentable]) -> Int? {
        guard let offset = SwiftDocKey.getOffset(from: ast) else { return nil }
        guard let length = SwiftDocKey.getLength(from: ast) else { return nil }
        
        let range = NSRange(location: Int(offset), length: Int(length))
        return self.file.lines.first(where: { $0.range.intersection(range) != nil })?.index
    }
    
}

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
