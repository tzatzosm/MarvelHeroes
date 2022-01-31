//
//  MarvelAPIService.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//

import Foundation
import Alamofire

protocol MarvelServiceInterface {
    func getCharacters(nameStartsWith: String?, order: String, offset: Int, limit: Int) async throws -> CharactersResponse
}

class MarvelService: MarvelServiceInterface {
    private let configuration = URLSessionConfiguration.default
    private let session: Alamofire.Session

    static let shared = MarvelService()

    private init() {
        session = Session(configuration: configuration, startRequestsImmediately: true)
    }

    func getCharacters(nameStartsWith: String?, order: String, offset: Int, limit: Int) async throws -> CharactersResponse {
        session.cancelAllRequests()
        let request = MarvelAPIServiceRouter.characters(
            nameStartsWith: nameStartsWith,
            order: order,
            offset: offset,
            limit: limit
        )
        return try await session.request(request).serializingDecodable(CharactersResponse.self).value
    }
}
