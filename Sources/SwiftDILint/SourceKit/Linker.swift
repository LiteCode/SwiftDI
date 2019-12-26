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
                
                let part = DIPart(id: register.objectType,
                                  kind: .register,
                                  location: register.location,
                                  registerObject: register.registerObject,
                                  parent: register.parent)
                context.parts.append(part)
            } else if let property = token as? SourceKitInjectedPropertyRepresentation {
                context.injected.append(property.injectedProperty)
            } else if let part = token as? SourceKitUndefinedDIPartRepresentation {
                let part = DIPart(id: part.name,
                                  kind: .extendedPart,
                                  location: part.location,
                                  registerObject: nil,
                                  parent: part.parent)
                context.parts.append(part)
            } else if let part = token as? SourceKitCustomDIPartRepresentation {
                let part = DIPart(id: part.name,
                                  kind: .extendedPart,
                                  location: part.location,
                                  registerObject: nil,
                                  parent: part.parent)
                context.parts.append(part)
            } else if let group = token as? SourceKitDIGroupRepresentation {
                let part = DIPart(id: group.groupId,
                                  kind: .group,
                                  location: group.location,
                                  registerObject: nil,
                                  parent: group.parent)
                context.parts.append(part)
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
        InjectedProperty(location: self.location,
                         injectedType: ObjectType(typeName: self.typeName),
                         placeInObject: ObjectType(typeName: self.parent))
    }
}
