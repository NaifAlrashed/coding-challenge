//
//  SearchResultsViewController.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import UIKit
import Combine

class SearchResultsViewController: UITableViewController {
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, SearchResult>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsCell.identifier, for: indexPath) as! SearchResultsCell
        cell.configure(model)
        return cell
    }
    
    private let searchStatus: AnyPublisher<State, Never>
    
    private var subscription: AnyCancellable?
    
    private let onJobSelected: (SearchResult) -> ()
    
    init(searchStatus: AnyPublisher<State, Never>, onjobSelected: @escaping (SearchResult) -> ()) {
        self.searchStatus = searchStatus
        self.onJobSelected = onjobSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.register(
            SearchResultsCell.self,
            forCellReuseIdentifier: SearchResultsCell.identifier
        )
        let snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>()
        dataSource.apply(snapshot)
        addLoadingIndicator()
        bind()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onJobSelected(dataSource.itemIdentifier(for: indexPath)!)
    }
    
    private func addLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
    
    private func bind() {
        subscription = searchStatus
            .sink { [weak self] newState in
                guard let self = self else { return }
                switch newState {
                case .idle:
                    self.loadingIndicator.stopAnimating()
                case .loading:
                    self.loadingIndicator.startAnimating()
                case let .searchResults(searchResults):
                    self.loadingIndicator.stopAnimating()
                    var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(searchResults)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                case let .error(message):
                    self.loadingIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default) { _ in
                        alert.dismiss(animated: true)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }
    }
}

fileprivate enum Section {
    case main
}
