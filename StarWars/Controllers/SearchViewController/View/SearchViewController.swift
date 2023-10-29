import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private var presenter: SearchViewPresenter?
    
    private lazy var starWarsDataTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let footerView = FooterViewWithLoadSpinner(startAnimatingImmediately: true)
        footerView.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height:  SearchViewConstants.heightForFooterView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StarWarsDataTableViewCell.self, forCellReuseIdentifier: StarWarsDataTableViewCell.reuseIdentifier)
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        //somechanges
        
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .systemGray
        
        return activityIndicatorView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle(ModuleTitles.favouriteButtonTitle.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: SearchViewConstants.favouriteButtonFontSize)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = SearchViewConstants.favouriteButtonCornerRadius
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: StarWarsPresentationModels.characters.title, at: .zero, animated: false)
        segmentedControl.insertSegment(withTitle: StarWarsPresentationModels.starships.title, at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.addTarget(self, action: #selector(selectionDidChange), for: .valueChanged)
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        configureSearchBar()
        
        presenter?.downloadedModelsIsConfigured()
    }
    
    @objc
    private func selectionDidChange() {
        presenter?.selectionDidChange(with: segmentedControl.selectedSegmentIndex)
    }
    
    @objc
    private func favouriteButtonTapped() {
        presenter?.favouriteButtonTapped()
    }
}

//MARK: - private
extension SearchViewController {
    private func addSubview() {
        view.addSubview(starWarsDataTableView)
        view.addSubview(segmentedControl)
        view.addSubview(favouriteButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(SearchViewConstants.heightForSegmentedControl)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(SearchViewConstants.segmentedControlTopOffset)
            $0.leading.equalToSuperview().inset(SearchViewConstants.defaultSideInset)
        }
        
        starWarsDataTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(SearchViewConstants.starWarsTableViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        favouriteButton.snp.makeConstraints {
            $0.top.width.height.equalTo(segmentedControl)
            $0.trailing.equalToSuperview().inset(SearchViewConstants.defaultSideInset)
        }
        
        activityIndicator.snp.makeConstraints {
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
    func downloadingDetailedInfo() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func finishedDownloadingDetailInfo() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
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
    func set(_ presenter: SearchViewPresenter) {
        self.presenter = presenter
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch presenter?.selectedSegment {
        case .characters:
            return presenter?.characterModelResult.results.count ?? .zero
            
        case .starships:
            return presenter?.starshipModelResult.results.count ?? .zero
            
        default: return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarWarsDataTableViewCell.reuseIdentifier, for: indexPath) as? StarWarsDataTableViewCell,
              let presenter else { return UITableViewCell() }
        
        switch presenter.selectedSegment {
        case .characters:
            let starWarsDataName = presenter.characterModelResult.results[indexPath.section].name
            let gender = presenter.characterModelResult.results[indexPath.section].gender
            let starshipAmount = presenter.characterModelResult.results[indexPath.section].starships?.count
            
            
            cell.configure(with: starWarsDataName, secondParameter: gender, amount: "Driving starship amount: \(starshipAmount ?? .zero)", isAddedToFavourite: false)
            
            return cell
            
        case.starships:
            let starshipName = presenter.starshipModelResult.results[indexPath.section].name
            let model = presenter.starshipModelResult.results[indexPath.section].model
            let manufacturer = presenter.starshipModelResult.results[indexPath.section].manufacturer
            let passengersAmount = presenter.starshipModelResult.results[indexPath.section].passengers
            
            cell.configure(with: """
                                 \(starshipName),
                                 \(model)
                                 """ , secondParameter: manufacturer, amount: passengersAmount, isAddedToFavourite: false)
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath)
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
