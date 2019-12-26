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
            
//            try context.validate()
            
            if #available(OSX 10.15, *) {
                let dependencyGraph = try context.dependencyGraph()
                let initialGraph = try context.partsInitialGraph()
                let graph = DILintGraph(version: version, dependencies: dependencyGraph, parts: initialGraph)
                
                let outputPath = rootPath.parent().url.appendingPathComponent("dilintgraph").appendingPathExtension("json")
                try graph.save(to: Path(outputPath.path))
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
    
}

@available(OSX 10.15, *)
struct DILintGraph: Codable {
    let version: String
    let dependencies: DependencyGraph
    let parts: PartInitialGraph
    
    func save(to path: Path) throws {
        let data = try JSONEncoder().encode(self)
        try path.write(data)
    }
}
