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
    case closure = "source.lang.swift.expr.closure"
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
        
        let tokens = try tokenizeAST(ast)
        return tokens
    }
    
    func tokenizeAST(_ ast: [String : SourceKitRepresentable]) throws -> [Token] {
        var tokens = [Token]()
        
        if let kindString = ast[SwiftDocKey.kind.rawValue] as? String, let kind = SourceKitKind(rawValue: kindString) {
            switch kind {
            case .class, .struct, .enum:
                let representations = try SourceKitDIPartRepresentation(ast: ast, fileName: self.fileName, file: self.file)
                print(representations)
            case .varClass, .varLocal, .varInstance, .varParameter, .varGlobal:
                let propertyWrapper = try SourceKitParamRepresentation(ast: ast, fileName: self.fileName, file: self.file)
                print(propertyWrapper)
            default:
                break
            }
        }

        
        if let children = ast[SwiftDocKey.substructure.rawValue] as? [[String: SourceKitRepresentable]] {
            for child in children {
                tokens += try tokenizeAST(child)
            }
        }
        
        return tokens
    }
    
}
