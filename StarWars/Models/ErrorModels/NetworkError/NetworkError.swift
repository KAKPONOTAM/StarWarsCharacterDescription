import Foundation

enum NetworkError: Error {
    case downloadFailed
    case missingData
    
    var errorDescription: String {
        switch self {
        case .downloadFailed:
            return "Download Failed. Please check your internet connection and try again."
            
        case .missingData:
            return "Something went wrong. Please try again later."
        }
    }
}
