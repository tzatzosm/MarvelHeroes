//
//  HerosResponse.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//

import Foundation

import Foundation

// MARK: - CharactersResponse
struct CharactersResponse: Codable {
    let code: Int?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: CharactersResponseData

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case copyright = "copyright"
        case attributionText = "attributionText"
        case attributionHTML = "attributionHTML"
        case etag = "etag"
        case data = "data"
    }
}

// MARK: - DataClass
struct CharactersResponseData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterData]?

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}

// MARK: - Result
struct CharacterData: Codable {
    let id: Int
    let name: String
    let resultDescription: String?
    let modified: String
    let thumbnail: Thumbnail

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case resultDescription = "description"
        case modified = "modified"
        case thumbnail = "thumbnail"
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}
