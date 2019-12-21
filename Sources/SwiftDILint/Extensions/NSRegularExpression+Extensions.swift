//
//  NSRegularExpression+Extensions.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

extension NSRegularExpression {
    convenience init(pattern: String) throws {
        try self.init(pattern: pattern, options: [])
    }
    
    func firstMatch(in string: String, range: NSRange) -> String? {
        guard let match = self.firstMatch(in: string, options: [], range: range) else { return nil }
        
        return (string as NSString).substring(with: match.range)
    }
}
