import Foundation

protocol SearchViewPresenterProtocol {}
protocol SearchViewProtocol: AnyObject {}

final class SearchViewPresenterImplementation: SearchViewPresenterProtocol {
    weak var viewController: SearchViewProtocol?
    
    init(viewController: SearchViewProtocol?) {
        self.viewController = viewController
    }
}
