import UIKit

protocol DefaultRouterProtocol {
    func start() -> UIViewController?
    func handleError(message: String?)
}
