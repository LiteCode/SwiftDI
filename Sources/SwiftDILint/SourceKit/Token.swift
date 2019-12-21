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
}


struct DIPartToken: Token {
//    let part: DIPart
    var offset: Int
    var length: Int
    var line: Int
}
