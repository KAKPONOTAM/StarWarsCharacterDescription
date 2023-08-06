import Foundation

protocol SearchViewPresenterProtocol {
    var characterModelResult: CharacterModelResult { get }
    var starshipModelResult: StarshipModelResult { get }
    
    func downloadedModelsIsConfigured()
    func textDidChange(with text: String)
    func textIsEmpty()
}

protocol SearchViewPresentDownloadProtocol {
    func willDisplayCell(at indexPath: IndexPath)
}

protocol SearchViewProtocol: AnyObject {
    func downloadingNewPage()
    func newPageIsDownloaded()
    
    func reloadData()
}

//MARK: - SearchViewPresenterProtocol
final class SearchViewPresenterImplementation: SearchViewPresenterProtocol {
    private weak var viewController: SearchViewProtocol?
    
    private let router: MainRouterProtocol
    private let networkManager: NetworkManagerProtocol
    
    private var filteredCharacterModelResult: CharacterModelResult
    private var filteredStarshipModelResult: StarshipModelResult
    
    var characterModelResult: CharacterModelResult
    var starshipModelResult: StarshipModelResult
    
    init(viewController: SearchViewProtocol?, router: MainRouterProtocol, networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) {
        self.viewController = viewController
        self.router = router
        self.networkManager = networkManager
        self.characterModelResult = characterModelResult
        self.starshipModelResult = starshipModelResult
        self.filteredStarshipModelResult = starshipModelResult
        self.filteredCharacterModelResult = characterModelResult
    }
    
    func downloadedModelsIsConfigured() {
        viewController?.downloadingNewPage()
    }
    
    func textIsEmpty() {
        characterModelResult.results = filteredCharacterModelResult.results
        
        viewController?.reloadData()
    }
    
    func textDidChange(with text: String) {
        let minimumSearchSymbolsCount = 2
        guard text.count >= minimumSearchSymbolsCount else { return }
        
        let filteredCharacters = Array(Set(filteredCharacterModelResult.results))
        let filteredCharacterResults = filteredCharacters.filter { $0.name.uppercased().contains(text.uppercased()) }
        
        characterModelResult.results = filteredCharacterResults
        
        viewController?.reloadData()
    }
}

//MARK: - SearchViewPresentDownloadProtocol
extension SearchViewPresenterImplementation: SearchViewPresentDownloadProtocol {
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == characterModelResult.results.count - 1,
           let nextPageURLAbsoluteString = characterModelResult.next {
            viewController?.downloadingNewPage()
            Task {
                let newCharacters: CharacterModelResult = try await networkManager.downloadInfo(urlAbsoluteString: nextPageURLAbsoluteString)
                
                filteredCharacterModelResult.results.append(contentsOf: newCharacters.results)
                characterModelResult.results.append(contentsOf: newCharacters.results)
                characterModelResult.next = newCharacters.next
                
                await MainActor.run {
                    viewController?.newPageIsDownloaded()
                    viewController?.reloadData()
                }
            }
        }
    }
}
