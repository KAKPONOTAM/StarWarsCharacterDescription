import UIKit

protocol MainRouterProtocol: DefaultRouterProtocol {
    func changeRootViewController(networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult)
}

final class MainRouterImplementation: MainRouterProtocol {
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
    
    func changeRootViewController(networkManager: NetworkManagerProtocol, characterModelResult: CharacterModelResult, starshipModelResult: StarshipModelResult) {
        viewController = ModuleBuilderImplementation.assemblySearchViewController(router: self, networkManager: networkManager, characterModelResult: characterModelResult, starshipModelResult: starshipModelResult)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window,
              let appBuilder = appDelegate.appBuilder else { return }
        
        appBuilder.createMainModule()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
