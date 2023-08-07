import UIKit
import SnapKit

final class StarWarsDataTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let favouriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(defaultImage: .favouriteImage)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let secondParameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: StarWarsDataTableViewCellConstants.secondParameterLabelFontSize)
        
        return label
    }()
    
    private let starshipDrivingAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let planetDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: StarWarsDataTableViewCellConstants.secondParameterLabelFontSize)
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: StarWarsDataTableViewCellConstants.secondParameterLabelFontSize)
        label.numberOfLines = .zero
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
        
        selectionStyle = .none
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func configure(with name: String?, secondParameter: String?, amount: String?, isAddedToFavourite: Bool, planetDescription: String? = .none, movieDescription: String? = .none) {
        nameLabel.text = name
        secondParameterLabel.text = secondParameter
        starshipDrivingAmountLabel.text = amount
        favouriteImageView.isHidden = !isAddedToFavourite
        planetDescriptionLabel.text = planetDescription
        movieDescriptionLabel.text = movieDescription
    }
}

//MARK: - private
extension StarWarsDataTableViewCell {
    private func addSubview() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(secondParameterLabel)
        containerView.addSubview(starshipDrivingAmountLabel)
        containerView.addSubview(favouriteImageView)
        containerView.addSubview(planetDescriptionLabel)
        containerView.addSubview(movieDescriptionLabel)
    }
    
    private func setupConstraints() {
        starshipDrivingAmountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
            $0.leading.equalTo(favouriteImageView.snp.trailing).offset(StarWarsDataTableViewCellConstants.nameLabelLeadingOffset)
        }
        
        secondParameterLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(starshipDrivingAmountLabel.snp.leading).offset(StarWarsDataTableViewCellConstants.secondParameterLabelTrailingOffset)
        }
        
        starshipDrivingAmountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(StarWarsDataTableViewCellConstants.defaultSideInset)
            $0.top.equalTo(secondParameterLabel)
        }
        
        favouriteImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(StarWarsDataTableViewCellConstants.favouriteImageViewLeadingOffset)
            $0.width.height.equalTo(StarWarsDataTableViewCellConstants.favouriteImageViewSize)
            $0.centerY.equalToSuperview()
        }
        
        planetDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(secondParameterLabel.snp.bottom)
            $0.leading.trailing.equalTo(secondParameterLabel)
        }
        
        movieDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(planetDescriptionLabel.snp.bottom)
            $0.leading.trailing.equalTo(secondParameterLabel)
            $0.bottom.equalToSuperview()
        }
    }
}
