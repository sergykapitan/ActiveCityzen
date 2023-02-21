//
//  RealmDAO.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 15.12.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import RealmSwift

class RealmDao <T: Object> : IRealmDao {
    
    //  MARK: setup
    
    var realm: Realm?
    init() {
        do {
            realm = try Realm(configuration: Realm.Configuration(schemaVersion: Constants.workoutRealmDatabaseSchemaVersion))
        } catch {
            print("Realm Initialization Error: \(error)")
        }
    }
    
    //   MARK: protocol implementation
    
    func save(_ object: T) -> Bool {
        guard let `realm` = realm else {
            return false
        }
        
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            return false
        }
        
        return true
    }
    
    func saveAll(_ objects: [T]) -> Int {
        var count = 0
        for obj in objects {
            if save(obj) { count += 1 }
        }
        return count
    }
    
    private func getAllResults() -> Results<T>? {
        return realm?.objects(T.self)
    }
    
    func getAll() -> [T] {
        guard let res = getAllResults() else { return [] }
        return Array(res)
    }
    
    func getAllFiltered(filter: String) -> [T] {
        guard let res = getAllResults() else { return [] }
        return Array(res.filter(filter))
    }
    
    func getByPrimaryKey(_ id: Any) -> T? {
        return self.realm?.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func deleteAll() {
        guard let res = getAllResults() else { return }
        
        do {
            try realm?.write {
                self.realm?.delete(res)
            }
        } catch {
            print("Realm Error Deleting Objects: \(error)")
            return
        }
    }
    
}
