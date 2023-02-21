//
//  DataExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 05.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import RxSwift

public extension Encodable {
    func asDictionary() -> [String: Any]? {
       guard let data = try? JSONEncoder().encode(self) else { return nil }
       return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
     }
}


public extension Data {
    func decode<T>(type: T.Type)-> T where T: Codable {
        do {
            // Decode data to object
            let jsonDecoder = JSONDecoder()
            let object = try jsonDecoder.decode(T.self, from: self)
            return object
        }
        catch {
            print("That shouldn't have happened")
        }
        fatalError()}
}

extension Dictionary {
    mutating func switchKey(fromKey: Key, toKey: Key) {
        if let entry = removeValue(forKey: fromKey) {
            self[toKey] = entry
        }
    }
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
