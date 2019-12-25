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
    
    @Flag("-fe", "--force-error", description: "Show errors instead of warning")
    var isForceError: Bool
    
    func execute() throws {
        let rootPath = Path(sourcePath)
        guard rootPath.isDirectory else {
            throw CommandError.invalidSourcePath(sourcePath)
        }
        let projectFilePaths = try rootPath.recursiveChildren().filter { $0.isFile && $0.extension == "swift" }
        
        do {
            let context = DILintContext(isForceError: isForceError)

            for path in projectFilePaths {
                guard let file = File(path: path.string) else { continue }
                let lexer = Lexer(file: file, filePath: path.string)
                let lexerTokens = try lexer.tokens()
                let linker = Linker(tokens: lexerTokens)
                try linker.link(into: context)
            }
            
            try context.validate()
            
            let graph = try context.getGraph()
            try graph.validate()
        } catch {
            fputs(error.localizedDescription, __stderrp)
            exit(-1)
        }
    }
    
}
