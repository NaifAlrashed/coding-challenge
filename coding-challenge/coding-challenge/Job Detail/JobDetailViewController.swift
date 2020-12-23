//
//  JobDetailViewController.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import UIKit

class JobDetailViewController: UIViewController {
    
    private let job: SearchResult
    
    private lazy var descriptionView: UIStackView = {
        let descriptionTitle = make(title: "Description")
        let descriptionDetail = make(detail: "")
        
        let attributedString = try! NSAttributedString(
            data: job.searchResultDescription.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        descriptionDetail.attributedText = attributedString
        return makeStackView(using: descriptionTitle, descriptionDetail)
    }()
    
    private lazy var stackView: UIStackView = {
        let typeView = makeTitleDetail(title: "Type", detail: job.type)
        let company = makeTitleDetail(title: "Company", detail: job.company)
        let url = makeTitleDetail(title: "URL", detail: job.url)
        let jobTitle = makeTitleDetail(title: "Title", detail: job.title)
        
        let stackView = UIStackView(arrangedSubviews: [typeView, company, url, jobTitle, descriptionView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let padding: CGFloat = 16
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: padding),
            scrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
        ])
        return scrollView
    }()
    
    init(job: SearchResult) {
        self.job = job
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    func layout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding * 2)
        ])
    }
    
    // MARK: - factory view methods
    
    private func makeTitleDetail(title: String, detail: String) -> UIStackView {
        
        let titleLabel = make(title: title)
        
        let detailLabel = make(detail: detail)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return makeStackView(using: titleLabel, detailLabel)
    }
    
    private func make(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = title
        return titleLabel
    }
    
    private func make(detail: String) -> UILabel {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .systemFont(ofSize: 17)
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.text = detail
        return detailLabel
    }
    
    private func makeStackView(using arrangeSubViews: UIView...) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangeSubViews)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
