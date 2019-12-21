//
//  String+Extensions.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation


extension String {
    var nsRange: NSRange {
        return NSRange(location: self.startIndex.utf16Offset(in: self), length: self.count)
    }
}
