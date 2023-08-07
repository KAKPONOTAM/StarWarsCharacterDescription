import Foundation
protocol FavouritesViewPresenterProtocol {
    func observeFavouriteModelInsertions()
}

final class FavouritesViewPresenterImplementation: FavouritesViewPresenterProtocol {
    private lazy var observedModels = realm.retrieveModels()
    private let realm: RealmManagerProtocol
    
    init(realm: RealmManagerProtocol) {
        self.realm = realm
    }
    
    func observeFavouriteModelInsertions() {
        realm.observe(models: observedModels) { [unowned self] updatedModels in
            guard let updatedModels else { return }
        }
    }
}
