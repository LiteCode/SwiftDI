//
//  FileLocation.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

struct FileLocation: Codable, Equatable, Hashable {
    let line: Int
    let file: String
    let characters: NSRange?
    let underlineText: String?
}
