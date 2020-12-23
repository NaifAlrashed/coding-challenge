//
//  AppFlowViewController.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import UIKit

class AppFlowViewController: UIViewController {
    
    private lazy var appNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .purple
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchViewController = makeSearchViewController()
        appNavigationController.pushViewController(searchViewController, animated: false)
        showMainNavigation()
    }
    
    private func showMainNavigation() {
        addChild(appNavigationController)
        view.addSubview(appNavigationController.view)
        appNavigationController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            appNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            appNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func makeSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel(jobsClient: .production)
        let searchViewController = SearchViewController(viewModel: viewModel) { [weak self] job in
            let viewController = JobDetailViewController(job: job)
            self?.appNavigationController.show(viewController, sender: nil)
        }
        return searchViewController
    }
}
