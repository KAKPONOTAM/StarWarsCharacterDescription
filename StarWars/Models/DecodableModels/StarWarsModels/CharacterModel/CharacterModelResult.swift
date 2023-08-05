import Foundation

struct CharacterModelResult: Decodable {
    let next: String?
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let name: String
    let height: String?
    let mass: String?
    let gender: String?
    let films: [String]?
    let starships: [String]?
}
