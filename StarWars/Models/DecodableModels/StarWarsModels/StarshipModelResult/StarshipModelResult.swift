import Foundation

struct StarshipModelResult: Decodable {
    let next: String?
    let results: [StarshipModel]
}

struct StarshipModel: Decodable {
    let name: String
    let model: String
    let manufacturer: String
    let pilots: [String]
    let passengers: String
}
