import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private var presenter: SearchPresenter?
    
    private lazy var starWarsDataTableView: UITableView = {
        let tableView = UITableView()
        let footerView = FooterViewWithLoadSpinner(startAnimatingImmediately: true)
        footerView.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height:  SearchViewConstants.heightForFooterView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StarWarsDataTableViewCell.self, forCellReuseIdentifier: StarWarsDataTableViewCell.reuseIdentifier)
        tableView.tableFooterView = footerView
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        configureSearchBar()
        
        presenter?.downloadedModelsIsConfigured()
    }
}

//MARK: - private
extension SearchViewController {
    private func addSubview() {
        view.addSubview(starWarsDataTableView)
    }
    
    private func setupConstraints() {
        starWarsDataTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = presenter?.characterModelResult.results.randomElement()?.name
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            presenter?.textIsEmpty()
            return
        }
        
        let dispatchWorkItem = DispatchWorkItem {
            self.presenter?.textDidChange(with: searchText)
        }
        
        Task.detached {
            let dispatchWorkItemResult = dispatchWorkItem.wait(timeout: .now() + 1)
           
            switch dispatchWorkItemResult {
            case .timedOut:
                await MainActor.run {
                    dispatchWorkItem.perform()
                }
                
            default: break
            }
        }
    }
}

//MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func reloadData() {
        starWarsDataTableView.reloadData()
    }
    
    func downloadingNewPage() {
        starWarsDataTableView.tableFooterView?.isHidden = false
    }
    
    func newPageIsDownloaded() {
        starWarsDataTableView.tableFooterView?.isHidden = true
    }
}

//MARK: - PresenterConfigurationProtocol
extension SearchViewController: PresenterConfigurationProtocol {
    func set(_ presenter: SearchPresenter) {
        self.presenter = presenter
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.characterModelResult.results.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsDataTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsDataTableViewCell,
              let presenter else { return UITableViewCell() }
        
        let starWarsDataName = presenter.characterModelResult.results[indexPath.row].name
        let gender = presenter.characterModelResult.results[indexPath.row].gender
        let starshipAmount = presenter.characterModelResult.results[indexPath.row].starships?.count
        
        
        cell.configure(with: starWarsDataName, gender: gender, starshipsAmount: starshipAmount ?? .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewConstants.defaultHeightForRow
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath)
    }
}
