import Foundation
import RealmSwift

@objcMembers
final class Movie: Object {
    dynamic var movieName: String = .emptyString
    dynamic var producer: String = .emptyString
    dynamic var director: String = .emptyString
    
    convenience init(movieName: String, producer: String, director: String) {
        self.init()
        self.movieName = movieName
        self.producer = producer
        self.director = director
    }
}
