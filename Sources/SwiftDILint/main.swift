import SourceKittenFramework
import PathKit
import Foundation
import SwiftCLI

let version: String = "2.0"

let cli = CLI(name: "swiftdi",
              version: version,
              description: "A tool for SwiftDI framework. Use it, if you wanna see error messages when you miss registration a object in Contaner. Work in compile time. Also can return json to visualize dependencies in project.",
              commands: [ValidateCommand()])

cli.goAndExit()
