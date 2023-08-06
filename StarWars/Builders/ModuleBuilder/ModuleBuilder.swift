import UIKit

protocol ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController
    static func assemblySearchViewController(router: MainRouterProtocol, networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) -> UIViewController
}

struct ModuleBuilderImplementation: ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController {
        let launchViewController = LaunchViewController()
        let networkManager = NetworkManagerImplementation()
        let presenter = LaunchPresenterImplementation(viewController: launchViewController, router: router, networkManager: networkManager)
        
        launchViewController.set(presenter)
        
        return launchViewController
    }
    
    static func assemblySearchViewController(router: MainRouterProtocol, networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) -> UIViewController {
        let searchViewController = SearchViewController()
        let presenter = SearchViewPresenterImplementation(viewController: searchViewController, router: router, networkManager: networkManager, characterModelResult: characterModelResult, starshipModelResult: starshipModelResult)
        let navigationController = UINavigationController(rootViewController: searchViewController)
        
        searchViewController.set(presenter)
        
        return navigationController
    }
}
