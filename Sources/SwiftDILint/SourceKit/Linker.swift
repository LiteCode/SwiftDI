//
//  Linker.swift
//  
//
//  Created by Vladislav Prusakov on 23.12.2019.
//

import Foundation
import SourceKittenFramework

class Linker {
    
    private let tokens: [Token]
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func link(into context: DILintContext) throws {
//        var diParts: [DIPart] = []
        var unusedDIParts: [DIPartRepresentable] = []
        
        for token in tokens {
            if let register = token as? SourceKitDIRegisterRepresentation {
                let registerObject = register.registerObject
                switch registerObject.lifeTime {
                case .single, .weakSingle:
                    context.singletones.append(registerObject)
                case .prototype:
                    context.prototypies.append(registerObject)
                case .objectGraph, .default:
                    context.graphObjects.append(registerObject)
                }
            } else if let property = token as? SourceKitInjectedPropertyRepresentation {
                context.injected.append(property.injectedProperty)
            } else if let undefinedPart = token as? SourceKitUndefinedDIPartRepresentation {
                unusedDIParts.append(undefinedPart)
            } else if let part = token as? SourceKitCustomDIPartRepresentation {
                unusedDIParts.append(part)
            } else if let group = token as? SourceKitDIGroupRepresentation {
                unusedDIParts.append(group)
            }
        }
    }
}

extension SourceKitDIRegisterRepresentation {
    var registerObject: RegisterObject {
        RegisterObject(lifeTime: self.lifeTime.flatMap { DILifeCycle(rawValue: $0) } ?? .default,
                       objectType: ObjectType(typeName: self.objectType),
                       additionalType: self.additionalTypes.map { ObjectType(typeName: $0) },
                       location: self.location)
    }
}

extension SourceKitInjectedPropertyRepresentation {
    var injectedProperty: InjectedProperty {
        InjectedProperty(location: self.location, injectedType: ObjectType(typeName: self.typeName))
    }
}
