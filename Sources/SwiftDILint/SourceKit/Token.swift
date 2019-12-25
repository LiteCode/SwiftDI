//
//  Token.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import Foundation

protocol Token: Codable {
    var offset: Int { get }
    var length: Int { get }
    var line: Int { get }
    var filePath: String { get }
    var characters: NSRange? { get }
    var underlineText: String? { get }
}

extension Token {
    var characters: NSRange? { return nil }
    var underlineText: String? { return nil }
}

extension Token {
    var location: FileLocation {
        return FileLocation(line: self.line,
                            file: self.filePath,
                            characters: self.characters,
                            underlineText: self.underlineText)
    }
}
