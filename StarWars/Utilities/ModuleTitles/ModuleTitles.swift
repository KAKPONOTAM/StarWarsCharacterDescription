import Foundation

enum ModuleTitles {
    case amount
    case favouriteButtonTitle
    case favourites
    
    var title: String? {
        switch self {
        case .amount:
            return "Amount"
            
        case .favouriteButtonTitle:
            return "Saved favourite"
            
        case .favourites:
            return "Favourites"
        }
    }
}

enum ErrorTitles {
    case savingSameModel
    
    var title: String? {
        switch self {
        case .savingSameModel:
            return "You can not save same models."
        }
    }
}
