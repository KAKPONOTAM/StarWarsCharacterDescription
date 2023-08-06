import Foundation

protocol PresenterConfigurationProtocol {
    associatedtype Presenter
    func set(_ presenter: Presenter)
}
