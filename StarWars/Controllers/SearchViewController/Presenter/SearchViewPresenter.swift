import Foundation

protocol SearchViewPresenterProtocol {}
protocol SearchViewProtocol: AnyObject {}

final class SearchViewPresenterImplementation: SearchViewPresenterProtocol {
    private weak var viewController: SearchViewProtocol?
    private let router: MainRouterProtocol
    private let networkManager: NetworkManagerProtocol
    private let characterModelResult: CharacterModelResult
    private let starshipModelResult: StarshipModelResult
    
    init(viewController: SearchViewProtocol?, router: MainRouterProtocol, networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) {
        self.viewController = viewController
        self.router = router
        self.networkManager = networkManager
        self.characterModelResult = characterModelResult
        self.starshipModelResult = starshipModelResult
    }
}
