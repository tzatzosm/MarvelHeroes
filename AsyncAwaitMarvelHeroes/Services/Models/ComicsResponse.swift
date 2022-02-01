//
//  ComicsResponse.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation

// MARK: - ComicsResponse -

struct ComicsResponse: Codable {
    let copyright: String?
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: ComicsResponseData

    enum CodingKeys: String, CodingKey {
        case copyright = "copyright"
        case attributionText = "attributionText"
        case attributionHTML = "attributionHTML"
        case etag = "etag"
        case data = "data"
    }
}

// MARK: - ComicsResponseData -

struct ComicsResponseData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [ComicData]

    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit = "limit"
        case total = "total"
        case count = "count"
        case results = "results"
    }
}

// MARK: - ComicData -

struct ComicData: Codable {
    let id: Int
    let digitalID: Int
    let title: String
    let variantDescription: String?
    let resultDescription: String?
    let modified: String
    let format: String
    let pageCount: Int
    let resourceURI: String
    let thumbnail: Thumbnail
    let images: [Thumbnail]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case digitalID = "digitalId"
        case title = "title"
        case variantDescription = "variantDescription"
        case resultDescription = "description"
        case modified = "modified"
        case format = "format"
        case pageCount = "pageCount"
        case resourceURI = "resourceURI"
        case thumbnail = "thumbnail"
        case images = "images"
    }
}
