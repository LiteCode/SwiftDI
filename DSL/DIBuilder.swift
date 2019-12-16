//
//  DIBuilder.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

@_functionBuilder
public struct DIBuilder {
    public static func buildBlock() -> EmptyDIPart {
        return EmptyDIPart()
    }
    
    public static func buildIf<T: DIPart>(_ content: T?) -> T? {
        return content
    }
}

extension DIBuilder {
    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> DITuplePart<(C0, C1)> where C0: DIPart, C1: DIPart {
        return .init((c0, c1))
    }
    
    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> DITuplePart<(C0, C1, C2)> where C0: DIPart, C1: DIPart, C2: DIPart {
        return .init((c0, c1, c2))
    }
    
    public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> DITuplePart<(C0, C1, C2, C3)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart {
        return .init((c0, c1, c2, c3))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> DITuplePart<(C0, C1, C2, C3, C4)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart {
        return .init((c0, c1, c2, c3, c4))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> DITuplePart<(C0, C1, C2, C3, C4, C5)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart, C5: DIPart {
        return .init((c0, c1, c2, c3, c4, c5))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> DITuplePart<(C0, C1, C2, C3, C4, C5, C6)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart, C5: DIPart, C6: DIPart {
        return .init((c0, c1, c2, c3, c4, c5, c6))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> DITuplePart<(C0, C1, C2, C3, C4, C5, C6, C7)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart, C5: DIPart, C6: DIPart, C7: DIPart {
        return .init((c0, c1, c2, c3, c4, c5, c6, c7))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> DITuplePart<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart, C5: DIPart, C6: DIPart, C7: DIPart, C8: DIPart {
        return .init((c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }
    
    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> DITuplePart<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where C0: DIPart, C1: DIPart, C2: DIPart, C3: DIPart, C4: DIPart, C5: DIPart, C6: DIPart, C7: DIPart, C8: DIPart, C9: DIPart {
        return .init((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }
}
