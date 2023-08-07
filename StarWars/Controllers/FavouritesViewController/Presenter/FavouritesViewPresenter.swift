import Foundation
import RealmSwift

protocol FavouritesViewPresenterProtocol: SwipeConfigurationWorkProtocol {
    func observeFavouriteModelInsertions()
    
    var starWarsFavouriteModels: [StarWarsRealmModel] { get }
}

protocol FavouritesViewProtocol: AnyObject {
    func reloadData()
}

final class FavouritesViewPresenterImplementation: FavouritesViewPresenterProtocol {
    private weak var viewController: FavouritesViewProtocol?
    private lazy var observedModels: Results<StarWarsRealmModel>? = realmManager.retrieveModels()
    private let realmManager: RealmManagerProtocol
    private let router: MainRouterProtocol
    
    var starWarsFavouriteModels: [StarWarsRealmModel] = .emptyCollection
    
    init(realmManager: RealmManagerProtocol, viewController: FavouritesViewProtocol?, router: MainRouterProtocol) {
        self.realmManager = realmManager
        self.viewController = viewController
        self.router = router
    }
    
    func observeFavouriteModelInsertions() {
        realmManager.observe(models: observedModels) { [unowned self] updatedModels in
            guard let updatedModels else { return }
            starWarsFavouriteModels = Array(updatedModels)
            
            viewController?.reloadData()
        }
    }
    
    func didSelectSwipeConfigurationItem(at indexPath: IndexPath) {
        let selectedModel = starWarsFavouriteModels[indexPath.section]
        realmManager.deleteModel(model: selectedModel)
    }
}
