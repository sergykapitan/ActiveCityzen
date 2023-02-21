//
//  File.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 22.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
struct Executable {
    var executableBlock: ()-> Void
    
    init(block: @escaping ()-> Void) {
        self.executableBlock = block
    }
    
    func execute() {
        executableBlock()
    }
}
