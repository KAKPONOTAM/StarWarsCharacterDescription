import UIKit
import SnapKit

final class FooterViewWithLoadSpinner: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        
        return indicator
    }()
    
    init(startAnimatingImmediately: Bool) {
        super.init(frame: .zero)
        addSubview()
        setupConstraints()
        startAnimating(startAnimatingImmediately)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

//MARK: - private
extension FooterViewWithLoadSpinner {
    private func addSubview() {
        addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - configuration functions
extension FooterViewWithLoadSpinner {
    func startAnimating(_ isNeedToStartAnimating: Bool) {
        isNeedToStartAnimating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
