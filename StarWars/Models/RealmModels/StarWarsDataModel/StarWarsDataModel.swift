import Foundation
import RealmSwift

@objcMembers
final class StarWarsModelData: Object {
    dynamic var name: String = ""
    dynamic var secondParameter: String = .emptyString
    dynamic var amount: String = .emptyString
    dynamic var primaryKey = UUID().uuidString
    
    var movies = List<Movie>()
    var planets = List<Planet>()
    
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
