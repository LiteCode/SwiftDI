//
//  File.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import Foundation

struct DIPart: Codable, Hashable, Equatable, Identifiable {
    let id: String
    let kind: DIPartKind
    let location: FileLocation
    let registerObject: RegisterObject?
    let parent: String?
}
