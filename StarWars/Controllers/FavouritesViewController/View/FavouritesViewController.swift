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

//MARK: - PresenterConfigurationProtocol
extension FavouritesViewController: PresenterConfigurationProtocol {
    func set(_ presenter: FavouritesViewPresenterProtocol) {
        self.presenter = presenter
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsDataTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsDataTableViewCell,
              let presenter else { return UITableViewCell() }
        
        return cell
    }
}
