//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import RealmSwift

class RealmStorage {
    
    enum TypePredicates {
        
        case stringAttribute(String)
        
        var embedExpression: String {
            switch self {
            case .stringAttribute(let attributeName):
                return "\(attributeName) == %@"
            default:
                return ""
            }
        }
    }
    
    static let shared = RealmStorage()
    private let realm = try? Realm()
    
}

extension RealmStorage {
    
    func save<T: Object>(_ object: T) {
        let queue = DispatchQueue(label: "realm", qos: .background)
        queue.async { [weak self] in
            guard let `self` = self else { return }
            try? self.realm?.write {
                print("Save \(object)")
                self.realm?.add(object)
            }
        }
    }
    
    func load<T: Object>() -> Results<T>? {
        let dataFromStorage = realm?.objects(T.self)
        return dataFromStorage ?? nil
    }
    
    func remove<T: Object>(_ objects: T,
                           predicate: TypePredicates,
                           whereName: String) {
        let predicate = NSPredicate(format: predicate.embedExpression, whereName)
        guard let object = realm?.objects(T.self).filter(predicate) else { return }
        try? realm?.write {
            realm?.delete(object)
        }
    }
    
    func searchAndFetchAllObject<T: Object>(with type: TypePredicates,
                                            value: String) -> Results<T>? {
        let predicate = NSPredicate(format: type.embedExpression, value)
        let dataFromStorageWithPredicate = realm?.objects(T.self).filter(predicate)
        return dataFromStorageWithPredicate
    }
}
