//
//  IRealmDao.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.12.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import RealmSwift

protocol IRealmDao {
    
    associatedtype T:Object
    
    func save(_ object: T) -> Bool
    
    func saveAll(_ objects: [T]) -> Int
    
    func getAll() -> [T]
    
    func getByPrimaryKey(_ id: Any) -> T?
    
    func deleteAll()
}
