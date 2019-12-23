import SourceKittenFramework
import PathKit
import Foundation


// Error for xcode
// {full_path_to_file}{:line}{:character}: {error,warning}: {content}

let root = "/Users/vladislavprusakov/Dev/XcodeDev/SwiftDI"
let swiftDIPath = "\(root)/Sources/SwiftDI/SwiftDI.swift"
let demo = "\(root)/SwiftDIDemo/SwiftDIDemo"
let assemblePath = "\(root)/SwiftDIDemo/SwiftDIDemo/home/Assembly/HomeAssembly.swift"
let appDelegatePath = "\(root)/SwiftDIDemo/SwiftDIDemo/AppDelegate.swift"

let path = Path(demo)
let projectFilePaths = try path.recursiveChildren().filter { $0.isFile && $0.extension == "swift" }

let context = DILintContext()

for path in projectFilePaths {
    guard let file = File(path: path.string) else { continue }
    let lexer = Lexer(file: file, fileName: path.lastComponent)
    let lexerTokens = try lexer.tokens()
    let linker = Linker(tokens: lexerTokens)
    try linker.link(into: context)
    print(lexerTokens)
}


try context.validate()
