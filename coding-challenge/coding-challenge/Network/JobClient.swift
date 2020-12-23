//
//  JobClient.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import Foundation
import Combine

struct JobClient {
    private let search: (String) -> AnyPublisher<[SearchResult], Error>
    
    init(searchEndpoint: @escaping (String) -> AnyPublisher<[SearchResult], Error>) {
        self.search = searchEndpoint
    }
    
    func search(for term: String) -> AnyPublisher<[SearchResult], Error> {
        search(term)
    }
}

extension JobClient {
    static let production = JobClient { searchTerm in
        URLSession.shared
            .dataTaskPublisher(
                for: URL(
                    string: "https://jobs.github.com/positions.json?search=\(searchTerm)"
                )!
            )
            .map(\.data)
            .decode(type: [SearchResult].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
