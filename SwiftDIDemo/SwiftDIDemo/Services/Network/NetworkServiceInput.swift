//
//  NetworkServiceInput.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftUI

protocol NetworkServiceInput {
    func getData(block: @escaping (Data?) -> Void)
}
