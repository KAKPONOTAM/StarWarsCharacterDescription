import UIKit

protocol MainRouterProtocol: DefaultRouterProtocol {}

final class MainRouterImplementation: MainRouterProtocol {
    private lazy var viewController = ModuleBuilderImplementation.assemblyLaunchViewController(router: self)
    
    func start() -> UIViewController? {
        return viewController
    }
}
