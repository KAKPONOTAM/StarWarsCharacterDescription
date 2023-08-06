import Foundation

protocol NetworkManagerProtocol {
    func downloadInfo<T: Decodable>(urlAbsoluteString: String) async throws -> T
}

struct NetworkManagerImplementation: NetworkManagerProtocol {
    func downloadInfo<T: Decodable>(urlAbsoluteString: String) async throws -> T {
        guard let url = URL(string: urlAbsoluteString) else { throw NetworkError.downloadFailed }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.missingData
        }
    }
}
