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
    var fileName: String { get }
}

extension Token {
    var location: FileLocation {
        return FileLocation(line: self.line, file: self.fileName)
    }
}
