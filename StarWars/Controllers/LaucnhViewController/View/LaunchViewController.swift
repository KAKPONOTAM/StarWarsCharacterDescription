import UIKit
import SnapKit

final class LaunchViewController: UIViewController {
    private var presenter: LaunchViewPresenterProtocol?
    
    private let launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(defaultImage: .launchImage)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        presenter?.downloadInfo()
    }
}

//MARK: - private
extension LaunchViewController {
    private func addSubview() {
        view.addSubview(launchImageView)
        view.addSubview(activityIndicator)
        
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func setupConstraints() {
        launchImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

//MARK: - PresenterConfigurationProtocol
extension LaunchViewController: PresenterConfigurationProtocol {
    func set(_ presenter: LaunchViewPresenterProtocol) {
        self.presenter = presenter
    }
}

//MARK: - LaunchViewProtocol
extension LaunchViewController: LaunchViewProtocol {
    func downloadBegin() {
        activityIndicator.startAnimating()
    }
}
