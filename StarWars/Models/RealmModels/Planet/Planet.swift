import Foundation
import RealmSwift

@objcMembers
final class Planet: Object {
    dynamic var planetName: String = .emptyString
    dynamic var diameter: String = .emptyString
    dynamic var populationAmount: String = .emptyString
    
    convenience init(planetName: String, diameter: String, populationAmount: String) {
        self.init()
        self.planetName = planetName
        self.diameter = diameter
        self.populationAmount = populationAmount
    }
}
