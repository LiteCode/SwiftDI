//
//  ValidateCommand.swift
//  
//
//  Created by Vladislav Prusakov on 24.12.2019.
//

import Foundation
import SwiftCLI
import PathKit
import SourceKittenFramework

class ValidateCommand: Command {
    
    let name: String = "validate"
    
    @Param var sourcePath: String
    
    func execute() throws {
        let rootPath = Path(sourcePath)
        guard rootPath.isDirectory else {
            throw CommandError.invalidSourcePath(sourcePath)
        }
        
        let projectFilePaths = try path.recursiveChildren().filter { $0.isFile && $0.extension == "swift" }
        
        let context = DILintContext()

        for path in projectFilePaths {
            guard let file = File(path: path.string) else { continue }
            let lexer = Lexer(file: file, fileName: path.lastComponent)
            let lexerTokens = try lexer.tokens()
            let linker = Linker(tokens: lexerTokens)
            try linker.link(into: context)
        }
        
        try context.validate()
    }
    
}
