import UIKit

protocol AppBuilderProtocol {
    func createMainModule()
}

final class AppBuilderImplementation: AppBuilderProtocol {
    private let window: UIWindow?
    private let router = MainRouterImplementation()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func createMainModule() {
        window?.rootViewController = router.start()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
