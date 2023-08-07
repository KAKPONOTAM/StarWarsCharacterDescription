import Foundation
import RealmSwift

protocol SearchViewPresenterProtocol: SwipeConfigurationWorkProtocol {
    var characterModelResult: CharacterModelResult { get }
    var starshipModelResult: StarshipModelResult { get }
    var selectedSegment: StarWarsPresentationModels { get }
    
    func downloadedModelsIsConfigured()
    func selectionDidChange(with index: Int)
    func favouriteButtonTapped()
}

protocol SearchViewPresenterTextConfigurationProtocol {
    func textDidChange(with text: String)
    func textIsEmpty()
}

protocol SearchViewPresenterDownloadProtocol {
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
    private let realmManager: RealmManagerProtocol
    
    private var filteredCharacterModelResult: CharacterModelResult
    private var filteredStarshipModelResult: StarshipModelResult
    private var starWarsSections = StarWarsPresentationModels.allCases
    private var realmModels: [StarWarsRealmModel] {
        guard let models: Results<StarWarsRealmModel> = realmManager.retrieveModels() else { return .emptyCollection }
        return Array(models)
    }
    
    var characterModelResult: CharacterModelResult
    var starshipModelResult: StarshipModelResult
    var selectedSegment: StarWarsPresentationModels = .characters
    
    init(viewController: SearchViewProtocol?, router: MainRouterProtocol, networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult, realmManager: RealmManagerProtocol) {
        self.viewController = viewController
        self.router = router
        self.networkManager = networkManager
        self.characterModelResult = characterModelResult
        self.starshipModelResult = starshipModelResult
        self.filteredStarshipModelResult = starshipModelResult
        self.filteredCharacterModelResult = characterModelResult
        self.realmManager = realmManager
    }
    
    func downloadedModelsIsConfigured() {
        viewController?.downloadingNewPage()
    }
    
    func selectionDidChange(with index: Int) {
        let selectedSegment = starWarsSections[index]
        self.selectedSegment = selectedSegment
        
        viewController?.reloadData()
    }
    
    func didSelectSwipeConfigurationItem(at indexPath: IndexPath) {
        let starWarsRealmModel = StarWarsRealmModel()
        
        switch selectedSegment {
        case .characters:
            let selectedModel = characterModelResult.results[indexPath.section]
            if realmModels.contains(where: { $0.name == selectedModel.name }) {
                router.handleError(message: ErrorTitles.savingSameModel.title)
                return
            }
            
            starWarsRealmModel.name = selectedModel.name
            starWarsRealmModel.secondParameter = selectedModel.gender ?? .emptyString
            starWarsRealmModel.amount = "\(selectedModel.starships?.count ?? .zero)"
            
        case .starships:
            let selectedModel = starshipModelResult.results[indexPath.section]
            if realmModels.contains(where: { $0.name == """
                                 \(selectedModel.name),
                                 \(selectedModel.model)
                                 """ }) {
                router.handleError(message: ErrorTitles.savingSameModel.title)
                return
            }
            
            starWarsRealmModel.name = """
                                 \(selectedModel.name),
                                 \(selectedModel.model)
                                 """
            starWarsRealmModel.secondParameter = selectedModel.manufacturer
            starWarsRealmModel.amount = selectedModel.passengers
        }
        
        realmManager.save(starWarsRealmModel)
        router.succesSave()
    }
    
    func favouriteButtonTapped() {
        router.pushFavouritesViewController()
    }
}

//MARK: - SearchViewPresentDownloadProtocol (download other models (depends selected segment) if we saw all, which downloaded before)
extension SearchViewPresenterImplementation: SearchViewPresenterDownloadProtocol {
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.section == characterModelResult.results.count - 1,
           let nextPageURLAbsoluteString = selectedSegment == .characters ? characterModelResult.next : starshipModelResult.next {
            viewController?.downloadingNewPage()
            Task {
                do {
                    switch selectedSegment {
                    case .characters:
                        let newCharacters: CharacterModelResult = try await networkManager.downloadInfo(urlAbsoluteString: nextPageURLAbsoluteString)
                        
                        filteredCharacterModelResult.results.append(contentsOf: newCharacters.results)
                        characterModelResult.results.append(contentsOf: newCharacters.results)
                        characterModelResult.next = newCharacters.next
                        
                    case .starships:
                        let newStarships: StarshipModelResult = try await networkManager.downloadInfo(urlAbsoluteString: nextPageURLAbsoluteString)
                        
                        filteredStarshipModelResult.results.append(contentsOf: newStarships.results)
                        starshipModelResult.results.append(contentsOf: newStarships.results)
                        starshipModelResult.next = newStarships.next
                    }
                    
                    await MainActor.run {
                        viewController?.newPageIsDownloaded()
                        viewController?.reloadData()
                    }
                } catch let error as NetworkError {
                    await MainActor.run {
                        router.handleError(message: error.errorDescription)
                    }
                }
            }
        }
    }
}

//MARK: - SearchViewPresenterTextConfigurationProtocol (present all downloaded models (depends selected segment) if text is empty )
extension SearchViewPresenterImplementation: SearchViewPresenterTextConfigurationProtocol {
    func textIsEmpty() {
        switch selectedSegment {
        case .characters:
            characterModelResult.results = filteredCharacterModelResult.results
            
        case .starships:
            starshipModelResult.results = filteredStarshipModelResult.results
        }
        
        viewController?.reloadData()
    }
    
    func textDidChange(with text: String) {
        let minimumSearchSymbolsCount = 2
        guard text.count >= minimumSearchSymbolsCount else { return }
        
        switch selectedSegment {
        case .characters:
            filterCharacterModel(with: text)
            
        case .starships:
            filterStarshipModelResult(with: text)
        }
        
        viewController?.reloadData()
    }
}

//MARK: - private (filter model depends selected segment)
extension SearchViewPresenterImplementation {
    private func filterCharacterModel(with text: String) {
        let filteredCharacters = Array(Set(filteredCharacterModelResult.results))
        let filteredCharacterResults = filteredCharacters.filter { $0.name.uppercased().contains(text.uppercased()) }
        
        characterModelResult.results = filteredCharacterResults
    }
    
    private func filterStarshipModelResult(with text: String) {
        let filteredStarships = Array(Set(filteredStarshipModelResult.results))
        let filteredStarshipResults = filteredStarships.filter { $0.name.uppercased().contains(text.uppercased()) }
        
        starshipModelResult.results = filteredStarshipResults
    }
}
