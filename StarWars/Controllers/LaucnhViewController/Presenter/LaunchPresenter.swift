import Foundation

protocol LaunchViewPresenterProtocol {
    func downloadInfo()
}

protocol LaunchViewProtocol: AnyObject {
    func downloadBegin()
}

final class LaunchPresenterImplementation: LaunchViewPresenterProtocol {
    private weak var viewController: LaunchViewProtocol?
    private let router: MainRouterProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(viewController: LaunchViewProtocol?, router: MainRouterProtocol, networkManager: NetworkManagerProtocol) {
        self.viewController = viewController
        self.router = router
        self.networkManager = networkManager
    }
    
    //MARK: - download start info on launch view to do not let user wait downloading on search view
    func downloadInfo() {
        viewController?.downloadBegin()
        
        Task {
            do {
                let starshipModelsResult: StarshipModelResult = try await networkManager.downloadInfo(urlAbsoluteString: URL.DefaultURLAbsoluteStrings.starships.urlAbsoluteString)
                let characterModelsResult: CharacterModelResult = try await networkManager.downloadInfo(urlAbsoluteString: URL.DefaultURLAbsoluteStrings.starWarsPeople.urlAbsoluteString)
                
                await MainActor.run {
                    router.changeRootViewController(characterModelResult: characterModelsResult, starshipModelResult: starshipModelsResult)
                }
                
            } catch let error as NetworkError {
                await MainActor.run {
                    router.handleError(message: error.errorDescription)
                }
            }
        }
    }
}
