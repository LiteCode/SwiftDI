import SourceKittenFramework
import PathKit
import Foundation


// Error for xcode
// {full_path_to_file}{:line}{:character}: {error,warning}: {content}

let root = "/Users/vladislavprusakov/Dev/XcodeDev/SwiftDI"
let swiftDIPath = "\(root)/Sources/SwiftDI/SwiftDI.swift"
let assemblePath = "\(root)/SwiftDIDemo/SwiftDIDemo/home/Assembly/HomeAssembly.swift"
let mm = "DIRegister(HomeViewModel.init)\n                .lifeCycle(.prototype)\n                .lifeCycle(.prototype)\n                .lifeCycle(.prototype)\n                .as"

let path = Path(assemblePath)
if let file = File(path: path.string) {
//    let structure = try Structure(file: file)
//    let tokens = try SyntaxMap(file: file)
//    print(structure.dictionary)
//    print("==========\n\n\n==========")
//    print(tokens.tokens)
//    
    let lexer = Lexer(file: file, fileName: path.lastComponent)
    let lexerTokens = try lexer.tokens()
    print(lexerTokens)
}

let obj = try RegisterObject(name: mm, line: 0, file: "")
print(obj)

class ASTParser {
    
    let ast: [String : SourceKitRepresentable]
    
    init(with ast: [String : SourceKitRepresentable]) {
        self.ast = ast
    }
    
    func parse(with context: DIContext) throws {
        
    }
}
