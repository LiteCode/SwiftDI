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
    
    @Flag("-e", "--force-error", description: "Show errors instead of warning")
    var isForceError: Bool
    
    @Key("--output-path", description: "Write by given path a json file with lint information")
    var outputPath: String?
    
    func execute() throws {
        let rootPath = Path(sourcePath)
        guard rootPath.isDirectory else {
            throw CommandError.invalidSourcePath(sourcePath)
        }
        let projectFilePaths = try rootPath.recursiveChildren().filter { $0.isFile && $0.extension == "swift" }
        
        do {
            if #available(OSX 10.15, *) {
                let context = DILintContext(isForceError: isForceError)
                
                var tokens: [Token] = []
                
                for path in projectFilePaths {
                    guard let file = File(path: path.string) else { continue }
                    let lexer = Lexer(file: file, filePath: path.string)
                    tokens += try lexer.tokens()
                }
                
                let linker = Linker(tokens: tokens)
                try linker.link(into: context)
                
                let result = try context.validate()
                
                if let outputPathString = self.outputPath {
                    try saveResult(result, at: outputPathString)
                }

            } else {
                throw CommandError.unsupportedOSX(minimal: "10.15")
            }
            
        } catch {
            if let cluster = error as? ErrorCluster {
                fputs(error.localizedDescription, __stderrp)
                exit(cluster.containsCriticalError ? EXIT_FAILURE : EXIT_SUCCESS)
            } else {
                fputs(error.localizedDescription, __stderrp)
                exit(EXIT_FAILURE)
            }
        }
    }
    
    // MARK: - Private
    
    @available(OSX 10.15, *)
    private func saveResult(_ result: DILintResult, at path: String) throws {
        let outputPath = Path(path)
        
        guard outputPath.isDirectory else {
            throw CommandError.invalidSourcePath(path)
        }
        
        guard outputPath.isWritable else {
            throw CommandError.nonWrittablePath(path)
        }
        
        let resultFilePath = outputPath.url.appendingPathComponent("dilintgraph").appendingPathExtension("json")
        try result.save(to: resultFilePath)
    }
    
}
