import UIKit
import SnapKit

final class StarWarsDataTableViewCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let starshipDrivingAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
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
    
    func configure(with name: String?, gender: String?, starshipsAmount: Int) {
        nameLabel.text = name
        genderLabel.text = gender
        starshipDrivingAmountLabel.text = "Driving starship amount: \(starshipsAmount)"
    }
}

//MARK: - private
extension StarWarsDataTableViewCell {
    private func addSubview() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(starshipDrivingAmountLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
        }
        
        starshipDrivingAmountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
            $0.centerY.equalToSuperview()
        }
    }
}
