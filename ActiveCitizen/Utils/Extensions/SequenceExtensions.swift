//
//  SequenceExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 16.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

extension Sequence {
    func sumBy(selector: (Element) -> Int) -> Int {
        return self.reduce(into: 0) { (sum, element) in
            sum += selector(element)
        }
    }
}
