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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
    }
}

//MARK: - private
extension LaunchViewController {
    private func addSubview() {
        view.addSubview(launchImageView)
    }
    
    private func setupConstraints() {
        launchImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
extension LaunchViewController: LaunchViewProtocol {}
