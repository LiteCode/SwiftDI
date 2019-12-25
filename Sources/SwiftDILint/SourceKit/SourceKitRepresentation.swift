//
//  SourceKitRepresentation.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import SourceKittenFramework
import Foundation

extension SwiftDocKey {
    /// Return access level for entity (String)
    static let accessebility = "key.accessibility"
    
    /// Return array of attributes ([[String : SourceKitRepresentable]])
    ///
    /// - Parameter `key.attribute` - information about attribute (accessability/propertyWrapper)
    /// - Parameter `key.length` - attribute length
    /// - Parameter `key.offset` - attribute offset
    static let attributes = "key.attributes"
    
    static let attribute = "key.attribute"
}

enum SwiftDocValue: String {
    case propertyWrapper = "source.decl.attribute._custom"
    case objc = "source.decl.attribute.objc"
    case argument = "source.lang.swift.expr.argument"
}

enum AccessibilityLevel: String, Codable {
    case `internal` = "source.lang.swift.accessibility.internal"
    case `public` = "source.lang.swift.accessibility.public"
    case `private` = "source.lang.swift.accessibility.private"
}

enum DIPartKind: String, Codable {
    case group
    case register
    case extendedPart
    case container
}

protocol DIPartRepresentable {
    var parent: String? { get }
    var kind: DIPartKind { get }
}
