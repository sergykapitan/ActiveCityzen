//
//  AtomicBool.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 09.11.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//
typealias Byte = UInt8

import Foundation

struct AtomicBoolean {

    private var val: Byte = 0

    /// Sets the value, and returns the previous value.
    /// The get/set is an atomic operation.
    mutating func getAndSet(value: Bool) -> Bool {
        if value {
            return OSAtomicTestAndSet(0, &val)
        } else {
            return OSAtomicTestAndClear(0, &val)
        }
    }

    /// Returns the current value of the boolean.
    /// The value may change before this method returns.
    func get() -> Bool {
        return val != 0
    }

}
