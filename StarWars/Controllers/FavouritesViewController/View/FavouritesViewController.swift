import UIKit
import SnapKit

final class FavouritesViewController: UIViewController {
    private var presenter: FavouritesViewPresenterProtocol?
    
    private lazy var starWarsDataTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StarWarsDataTableViewCell.self, forCellReuseIdentifier: StarWarsDataTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        presenter?.observeFavouriteModelInsertions()
    }
}

//MARK: - private
extension FavouritesViewController {
    private func addSubview() {
        view.addSubview(starWarsDataTableView)
    }
    
    private func setupConstraints() {
        starWarsDataTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FavouritesViewController: FavouritesViewProtocol {
    func reloadData() {
        starWarsDataTableView.reloadData()
    }
}

//MARK: - PresenterConfigurationProtocol
extension FavouritesViewController: PresenterConfigurationProtocol {
    func set(_ presenter: FavouritesViewPresenterProtocol) {
        self.presenter = presenter
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.starWarsFavouriteModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsDataTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsDataTableViewCell,
              let presenter else { return UITableViewCell() }
        
        let name = presenter.starWarsFavouriteModels[indexPath.section].name
        let secondParameter = presenter.starWarsFavouriteModels[indexPath.section].secondParameter
        let amount = presenter.starWarsFavouriteModels[indexPath.section].amount
        
        cell.configure(with: name, secondParameter: secondParameter, amount: amount, isAddedToFavourite: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavouritesViewConstants.heightForRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavoriteAction = UIContextualAction(style: .normal, title: .none) { action, view, handler in
            self.presenter?.didSelectSwipeConfigurationItem(at: indexPath)
            handler(true)
        }
        
        addToFavoriteAction.image = UIImage(defaultImage: .favouriteImage)
        
        return UISwipeActionsConfiguration(actions: [addToFavoriteAction])
    }
}
