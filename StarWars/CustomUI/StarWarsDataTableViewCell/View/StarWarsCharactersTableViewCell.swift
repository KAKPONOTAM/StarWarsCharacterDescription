import UIKit
import SnapKit

final class StarWarsDataTableViewCell: UITableViewCell {
    private let containerForLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let secondParameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let starshipDrivingAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = .zero
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func configure(with name: String?, secondParameter: String?, amount: String?) {
        nameLabel.text = name
        secondParameterLabel.text = secondParameter
        starshipDrivingAmountLabel.text = amount
    }
}

//MARK: - private
extension StarWarsDataTableViewCell {
    private func addSubview() {
        contentView.addSubview(containerForLabel)
        
        containerForLabel.addSubview(nameLabel)
        containerForLabel.addSubview(secondParameterLabel)
        containerForLabel.addSubview(starshipDrivingAmountLabel)
    }
    
    private func setupConstraints() {
        starshipDrivingAmountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        containerForLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
        }
        
        secondParameterLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(starshipDrivingAmountLabel.snp.leading).offset(-5)
        }
        
        starshipDrivingAmountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
            $0.top.equalTo(secondParameterLabel)
        }
    }
}
