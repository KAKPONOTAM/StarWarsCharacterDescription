import UIKit
import SnapKit

final class StarWarsDataTableViewCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        
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
    
    func configure(with name: String?) {
        nameLabel.text = name
    }
}

//MARK: - private
extension StarWarsDataTableViewCell {
    private func addSubview() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(StarWarsDataTableViewCellConstants.nameLabelSideInset)
        }
    }
}
