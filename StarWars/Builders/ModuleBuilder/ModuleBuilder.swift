import UIKit

protocol ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController
    static func assemblySearchViewController(router: MainRouterProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) -> UIViewController
}

struct ModuleBuilderImplementation: ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController {
        let launchViewController = LaunchViewController()
        let networkManager = NetworkManagerImplementation()
        let presenter = LaunchPresenterImplementation(viewController: launchViewController, router: router, networkManager: networkManager)
        
        launchViewController.set(presenter)
        
        return launchViewController
    }
    
    static func assemblySearchViewController(router: MainRouterProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) -> UIViewController {
        let searchViewController = SearchViewController()
        let realmManager = RealmManagerImplementation()
        let networkManager = NetworkManagerImplementation()
        let presenter = SearchViewPresenterImplementation(viewController: searchViewController, router: router, networkManager: networkManager, characterModelResult: characterModelResult, starshipModelResult: starshipModelResult, realmManager: realmManager)
        let navigationController = UINavigationController(rootViewController: searchViewController)
        
        searchViewController.set(presenter)
        
        return navigationController
    }
    
    static func assemblyFavouritesViewController(router: MainRouterProtocol) -> UIViewController {
        let favouriteViewController = FavouritesViewController()
        let realmManager = RealmManagerImplementation()
        let presenter = FavouritesViewPresenterImplementation(realmManager: realmManager, viewController: favouriteViewController, router: router)
        
        favouriteViewController.set(presenter)
        
        return favouriteViewController
    }
}
