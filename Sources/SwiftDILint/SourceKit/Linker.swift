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
        let filtredTokens = self.removeUndefindParts(from: tokens)
        for token in filtredTokens {
            autoreleasepool {
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
                } else if let container = token as? SourceKitDIContainerRepresentation {
                    let part = DIPart(id: container.id,
                                      kind: .container,
                                      location: container.location,
                                      registerObject: nil,
                                      parent: container.parent)
                    context.parts.append(part)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func removeUndefindParts(from tokens: [Token]) -> [Token] {
        var oldTokens = tokens
        var filterTokens = Array<Token>()
        filterTokens.reserveCapacity(tokens.count)
        
        var undefinedDIPart: [SourceKitUndefinedDIPartRepresentation] = oldTokens.dropAll(where: { $0 is SourceKitUndefinedDIPartRepresentation }).map { $0 as! SourceKitUndefinedDIPartRepresentation }
//        let extendedDIPart [SourceKitCustomDIPartRepresentation] = tokens.compactMap { $0 as? SourceKitCustomDIPartRepresentation }
        
        for token in oldTokens {
            autoreleasepool {
                if let extendedDIPart = token as? SourceKitCustomDIPartRepresentation {
                    let parts = undefinedDIPart.dropAll { $0.name == extendedDIPart.name }
                    
                    filterTokens.append(extendedDIPart)
                    
                    for part in parts {
                        let newPart = SourceKitCustomDIPartRepresentation(undefined: part, from: extendedDIPart)
                        filterTokens.append(newPart)
                    }
                    
                } else {
                    filterTokens.append(token)
                }
            }
        }
        
        return filterTokens
    }
}

fileprivate extension Array {
    mutating func dropAll(where satisfy: (Element) -> Bool) -> [Element] {
        
        var items: [Element] = []
        var indexToDelete: [Array.Index] = []
        let copy = self
        
        for (index, item) in copy.enumerated() {
            autoreleasepool {
                if satisfy(item) {
                    items.append(item)
                    indexToDelete.append(index)
                }
            }
        }
        
        var step = 0
        
        for index in indexToDelete {
            self.remove(at: index - step)
            step += 1
        }
        
        return items
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
