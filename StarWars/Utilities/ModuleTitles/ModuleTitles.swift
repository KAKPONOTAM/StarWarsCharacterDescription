import Foundation

enum ModuleTitles {
    case amount
    
    var title: String? {
        switch self {
        case .amount:
            return "Amount"
        }
    }
}
