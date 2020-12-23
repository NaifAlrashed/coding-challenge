//
//  SearchViewModel.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import Foundation
import Combine

class SearchViewModel {
    
    @Published var state = SearchState()
    
    private let jobsClient: JobClient
    
    private var searchSubscription: AnyCancellable?
    
    let scheduler: some Scheduler = DispatchQueue.main
    
    init(jobsClient: JobClient) {
        self.jobsClient = jobsClient
    }
    
    func search(for term: String) {
        if term.isEmpty {
            return
        }
        state.status = .loading
        searchSubscription = jobsClient.search(for: term)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state.status = .loading
            })
            .print("viewModel")
            .receive(on: scheduler)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state.status = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] searchResults in
                self?.state.status = .searchResults(searchResults)
            }

    }
}

struct SearchState {
    var selected: SearchResult? = nil
    var status: State = .idle
}
