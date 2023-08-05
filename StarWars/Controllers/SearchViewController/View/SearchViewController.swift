import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private var presenter: SearchViewPresenterProtocol?
    
    private lazy var charactersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
    }
}

//MARK: - private
extension SearchViewController {
    private func addSubview() {
        view.addSubview(charactersCollectionView)
    }
    
    private func setupConstraints() {
        charactersCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {}


//MARK: - PresenterConfigurationProtocol
extension SearchViewController: PresenterConfigurationProtocol {
    func set(_ presenter: SearchViewPresenterProtocol) {
        self.presenter = presenter
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - layout.minimumInteritemSpacing)
    }
}
