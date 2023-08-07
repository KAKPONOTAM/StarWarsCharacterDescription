import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func save<T: Object>(_ model: T)
    func deleteModel<T: Object>(model: T)
    func retrieveModels<T: Object>() -> Results<T>?
    func update(completion: @escaping () -> Void)
    
    @discardableResult func observe<T>(models: Results<T>?, completion: @escaping(Results<T>?) -> Void) -> NotificationToken?
}

final class RealmManagerImplementation: RealmManagerProtocol {
    private var notificationToken: NotificationToken?
    
    private let realm: Realm? = {
        let realm = try? Realm()
        
        return realm
    }()
    
    func save<T: Object>(_ model: T) {
        do {
            try? realm?.write {
                realm?.add(model)
            }
        }
    }
    
    func deleteModel<T: Object>(model: T) {
        do {
            try? realm?.write {
                realm?.delete(model)
            }
        }
    }
    
    func retrieveModels<T: Object>() -> Results<T>? {
        return realm?.objects(T.self)
    }
    
    func update(completion: @escaping () -> Void) {
        do {
            try? realm?.write {
                completion()
            }
        }
    }
    
    @discardableResult func observe<T>(models: Results<T>?, completion: @escaping(Results<T>?) -> Void) -> NotificationToken? {
        notificationToken = models?.observe {
            switch $0 {
            case .initial(let result):
                completion(result)
                
            case .update(let result, deletions: _, insertions: _, modifications: _):
                completion(result)
                
            case .error(let error):
                debugPrint(error.localizedDescription)
            }
        }
        
        return notificationToken
    }
}
