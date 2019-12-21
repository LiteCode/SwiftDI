//
//  RegisterObject.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

struct RegisterObject: Codable {
    var lifeTime: String
    var objectType: ObjectType
    var additionalType: [ObjectType]
    var location: FileLocation
    
    init(name: String, line: Int, file: String) throws {
        self.location = FileLocation(line: line, file: file)
        
        let tokens = Self.parse(name: name)
        
        var registerObject: ObjectType?
        var additionalTypes: [ObjectType] = []
        var lifeTime: String?
        
        for token in tokens {
            switch token {
            case .as(let objectType):
                additionalTypes.append(objectType)
            case .register(let object):
                registerObject = object
            case .lifeTime(let time):
                lifeTime = time
            }
        }
        
        guard let mainObject = registerObject else {
            fatalError("Register object not found in file \(file) at line \(line)")
        }
        
        
        
        self.objectType = registerObject!
        self.lifeTime = lifeTime!
        self.additionalType = additionalTypes
    }
    
    enum Token {
        case register(ObjectType)
        case `as`(ObjectType)
        case lifeTime(String)
    }
    
    static func parse(name: String) -> [Token] {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let elements = trimmedName.split(separator: Character("\n")).map(String.init).map { $0.trimmingCharacters(in: .whitespaces) }
        
        let regular = try! NSRegularExpression(pattern: "\\((.*?)\\)")
        
        var tokens: [Token] = []
        
        for element in elements {
            if element.hasPrefix("DIRegister") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: ".init", with: "")
                    tokens.append(.register(ObjectType(name: name)))
                }
            } else if element.hasPrefix(".lifeCycle") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: ".", with: "")
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                    tokens.append(.lifeTime(name))
                }
            } else if element.hasPrefix(".as") {
                if let match = regular.firstMatch(in: element, range: element.nsRange) {
                    let name = match
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: ".self", with: "")
                    tokens.append(.as(ObjectType(name: name)))
                }
            }
        }
        
        return tokens
    }
}
