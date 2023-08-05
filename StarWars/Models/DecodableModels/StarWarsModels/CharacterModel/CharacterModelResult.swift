import Foundation

struct CharacterModelResult: Decodable {
    var next: String?
    var results: [CharacterModel]
}

struct CharacterModel: Hashable, Decodable {
    let name: String
    let height: String?
    let mass: String?
    let gender: String?
    let films: [String]?
    let starships: [String]?
    let homeworld: String
}
