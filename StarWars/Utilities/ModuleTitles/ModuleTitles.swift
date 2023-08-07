import Foundation

enum ModuleTitles {
    case amount
    case favouriteButtonTitle
    
    var title: String? {
        switch self {
        case .amount:
            return "Amount"
            
        case .favouriteButtonTitle:
            return "Saved favourite"
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
