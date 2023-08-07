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
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        presenter?.observeFavouriteModelInsertions()
        title = ModuleTitles.favourites.title
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.starWarsFavouriteModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsDataTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsDataTableViewCell,
              let presenter else { return UITableViewCell() }
        
        let favouriteModel = presenter.starWarsFavouriteModels[indexPath.section]
        let name = favouriteModel.name
        let secondParameter = favouriteModel.secondParameter
        let amount = favouriteModel.amount
        let planet = favouriteModel.planet ?? Planet(planetName: .emptyString, diameter: .emptyString, populationAmount: .emptyString)
        let planetDescription = "Planet Name: \(planet.planetName), Diameter: \(planet.diameter), Population: \(planet.populationAmount)"
        let movieDescription = favouriteModel.movies.map { "\($0.movieName): Director: \($0.director), Producer: \($0.producer) \n" }.joined(separator: "\n")
        
        cell.configure(with: name, secondParameter: secondParameter, amount: amount, isAddedToFavourite: true, planetDescription: planetDescription, movieDescription: movieDescription)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
