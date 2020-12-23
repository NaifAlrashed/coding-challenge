//
//  SearchViewController.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var titleView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchResultsController = SearchResultsViewController(
        searchStatus: viewModel
            .$state
            .eraseToAnyPublisher(),
        onjobSelected: onJobSelected
    )
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(
            searchResultsController: searchResultsController
        )
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private let viewModel: SearchViewModel
    
    private let onJobSelected: (SearchResult) -> ()
    
    init(viewModel: SearchViewModel, onJobSelected: @escaping (SearchResult) -> ()) {
        self.viewModel = viewModel
        self.onJobSelected = onJobSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleView
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .purple
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(for: searchController.searchBar.text!)
    }
}
