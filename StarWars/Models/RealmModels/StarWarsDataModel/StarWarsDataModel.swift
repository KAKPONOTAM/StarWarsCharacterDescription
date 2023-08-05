import Foundation
import RealmSwift

@objcMembers
final class StarWarsRealmModel: Object {
    dynamic var name: String = .emptyString
    dynamic var secondParameter: String = .emptyString
    dynamic var amount: String = .emptyString
    dynamic var primaryKey = UUID().uuidString
    dynamic var planet: Planet? = .none
    
    var movies = List<Movie>()
    
    convenience init(name: String, secondParameter: String, amount: String) {
        self.init()
        self.name = name
        self.secondParameter = secondParameter
        self.amount = amount
    }
    
    override class func primaryKey() -> String? {
        return "primaryKey"
    }
}
