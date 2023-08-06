import UIKit
import SnapKit

final class HeaderView: UIView {
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.text = ModuleTitles.amount.title
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

//MARK: - private
extension HeaderView {
    private func addSubview() {
        addSubview(amountLabel)
    }
    
    private func setupConstraints() {
        amountLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(HeaderViewConstants.amountLabelSideInset)
        }
    }
}
