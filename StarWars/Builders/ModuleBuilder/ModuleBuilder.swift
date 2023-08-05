import UIKit

protocol ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController
}

struct ModuleBuilderImplementation: ModuleBuilderProtocol {
    static func assemblyLaunchViewController(router: MainRouterProtocol) -> UIViewController {
        let launchViewController = LaunchViewController()
        let presenter = LaunchPresenterImplementation(viewController: launchViewController)
        
        launchViewController.set(presenter)
        
        return launchViewController
    }
}
