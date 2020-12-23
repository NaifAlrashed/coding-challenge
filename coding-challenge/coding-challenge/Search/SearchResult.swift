//
//  SearchResult.swift
//  coding-challenge
//
//  Created by Naif Alrashed on 23/12/2020.
//

import Foundation

struct SearchResult: Hashable, Decodable {
    let type: String
    let url: String
    let company: String
    let title: String
    let searchResultDescription: String
    
    enum CodingKeys: String, CodingKey {
        case type, url
        case company
        case title
        case searchResultDescription = "description"
    }
}
