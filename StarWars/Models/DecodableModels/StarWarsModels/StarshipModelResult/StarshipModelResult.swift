import Foundation

struct StarshipModelResult: Decodable {
    var next: String?
    var results: [StarshipModel]
}

struct StarshipModel: Decodable, Hashable {
    let name: String
    let model: String
    let manufacturer: String
    let pilots: [String]
    let passengers: String
}
