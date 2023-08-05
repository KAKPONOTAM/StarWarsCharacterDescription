import UIKit

protocol DefaultRouterProtocol {
    func start() -> UIViewController?
    func handleError(message: String?)
    func dismiss(completion: (() -> Void)?)
    func popViewController()
}
