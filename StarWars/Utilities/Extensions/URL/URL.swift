import Foundation

extension URL {
   public enum DefaultURLAbsoluteStrings {
        case starWarsPeople
        case starWarsPlanets
        case starships
        
        
        var urlAbsoluteString: String {
           switch self {
           case .starWarsPeople:
               return "https://swapi.dev/api/people/"
               
           case .starWarsPlanets:
               return "https://swapi.dev/api/planets/"
               
           case .starships:
               return "https://swapi.dev/api/starships/"
           }
       }
    }
}
