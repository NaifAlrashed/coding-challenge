//
//  SearchViewModel.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import Foundation
import Combine

class SearchViewModel {
    
    @Published var state: SearchState = .idle
    
    private let jobsClient: JobClient
    
    private var searchSubscription: AnyCancellable?
    
    let scheduler: some Scheduler = DispatchQueue.main // this should be a generic AnyScheduler to inject a testing scheduler for testing, but combine doesn't come with one. There are libraries that does that.
    
    init(jobsClient: JobClient) {
        self.jobsClient = jobsClient
    }
    
    func search(for term: String) {
        if term.isEmpty {
            return
        }
        state = .loading
        searchSubscription = jobsClient.search(for: term)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            })
            .print("viewModel")
            .receive(on: scheduler)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] searchResults in
                self?.state = .searchResults(searchResults)
            }

    }
}

enum SearchState: Hashable {
    case idle
    case loading
    case error(String)
    case searchResults([SearchResult])
}
