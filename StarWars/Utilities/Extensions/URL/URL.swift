import Foundation

extension URL {
   public enum DefaultURLAbsoluteStrings {
        case starWarsPeople
        case starships
        
        
        var urlAbsoluteString: String {
           switch self {
           case .starWarsPeople:
               return "https://swapi.dev/api/people/"
               
           case .starships:
               return "https://swapi.dev/api/starships/"
           }
       }
    }
}
