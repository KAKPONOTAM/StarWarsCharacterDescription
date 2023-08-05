import Foundation

protocol LaunchViewPresenterProtocol {}
protocol LaunchViewProtocol: AnyObject {}

final class LaunchPresenterImplementation: LaunchViewPresenterProtocol {
    weak var viewController: LaunchViewProtocol?
    
    init(viewController: LaunchViewProtocol?) {
        self.viewController = viewController
    }
}
