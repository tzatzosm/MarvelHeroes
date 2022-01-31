//
//  MockMarvelService.swift
//  AsyncAwaitMarvelHeroesTests
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation
@testable import AsyncAwaitMarvelHeroes

struct MockMarvelService: MarvelServiceInterface {
    let total: Int

    func getCharacters(nameStartsWith: String?, order: String, offset: Int, limit: Int) async throws -> CharactersResponse {
        let thumbnail = Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/80/5317738e6dc12", thumbnailExtension: "jpg")
        let character = CharacterData(
            id: 1,
            name: "Thor",
            resultDescription: nil,
            modified: "",
            thumbnail: thumbnail)
        let characters = [character]
        let data = CharactersResponseData(offset: 0, limit: 1, total: total, count: 1, results: characters)
        return CharactersResponse(
            code: 200,
            copyright: nil,
            attributionText: nil,
            attributionHTML: nil,
            etag: nil,
            data: data)
    }

}
