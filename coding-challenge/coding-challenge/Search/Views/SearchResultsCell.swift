//
//  SearchResultsCell.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import UIKit

class SearchResultsCell: UITableViewCell {

    static let identifier = "SearchResultsCell"
    
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .boldSystemFont(ofSize: 17)
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    
    private let jobDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = .boldSystemFont(ofSize: 17)
        description.numberOfLines = 0
        description.lineBreakMode = .byWordWrapping
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [title, jobDescription])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ searchResult: SearchResult) {
        title.text = searchResult.company
        jobDescription.text = searchResult.title
    }
}
