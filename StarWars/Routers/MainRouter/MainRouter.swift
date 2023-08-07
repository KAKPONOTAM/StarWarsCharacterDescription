import UIKit

protocol MainRouterProtocol: DefaultRouterProtocol {
    func changeRootViewController(characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult)
    func pushFavouritesViewController()
    func succesSave()
}

final class MainRouterImplementation: MainRouterProtocol {
    func dismiss(completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: true, completion: completion)
    }
    
    func popViewController() {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    private lazy var viewController = ModuleBuilderImplementation.assemblyLaunchViewController(router: self)
    
    func start() -> UIViewController? {
        return viewController
    }
    
    func handleError(message: String?) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func changeRootViewController(characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) {
        viewController = ModuleBuilderImplementation.assemblySearchViewController(router: self, characterModelResult: characterModelResult, starshipModelResult: starshipModelResult)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window,
              let appBuilder = appDelegate.appBuilder else { return }
        
        appBuilder.createMainModule()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func pushFavouritesViewController() {
        let favouritesViewController = ModuleBuilderImplementation.assemblyFavouritesViewController(router: self)
        guard let navigationController = viewController as? UINavigationController else { return }
        
        navigationController.pushViewController(favouritesViewController, animated: true)
    }
    
    func succesSave() {
        let alertController = UIAlertController(title: "Success!", message: "Selected item successfully saved!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
}
