import Foundation

enum StarWarsPresentationModels: CaseIterable {
    case charactersf
    case starships
    
    var title: String? {
        switch self {
        case .characters:
            return "Characters"
            
        case .starships:
            return "Starships"
        }
    }
}
