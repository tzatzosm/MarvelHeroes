//
//  MarvelServiceRouter.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//

import Foundation
import Alamofire

enum MarvelAPIServiceRouter: URLRequestConvertible {

    case characters(nameStartsWith: String?, order: String, offset: Int, limit: Int)
    case comics(characterIds: [Int])

    var version: String {
        return "v1"
    }

    var path: String {
        switch self {
        case .characters:
            return "public/characters"
        case .comics:
            return "public/comics"
        }
    }

    // Proper way to do this would be to use Alamofire's request adapter,
    // but because this API passes the keys & hash in the request params it way more convenient to do this here.
    fileprivate var authQueryStringParams: [URLQueryItem] {
        let timestamp = Date().timeIntervalSince1970
        return [URLQueryItem(name: "ts", value: String(timestamp)),
                URLQueryItem(name: "apikey", value: Environment.current.publicApiKey),
                URLQueryItem(name: "hash", value: "\(timestamp)\(Environment.current.privateApiKey)\(Environment.current.publicApiKey)".MD5())]
    }

    var queryStringParams: [URLQueryItem] {
        switch self {
        case let .characters(nameStartsWith, order, offset, limit):
            var queryItems = [
                URLQueryItem(name: "orderBy", value: order),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
            if let nameStartsWith = nameStartsWith {
                queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
            }
            return queryItems
        case let .comics(characterIds):
            let characterIds = characterIds.map { "\($0)" }.joined(separator: ",")
            return [URLQueryItem(name: "characters", value: characterIds)]
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .characters, .comics:
            return .get
        }
    }

    var url: String {
        return "https://gateway.marvel.com/\(version)/\(path)"
    }

    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: self.url) else {
            fatalError("Could not build URLComponents for url: \(self.url)")
        }

        urlComponents.queryItems = self.authQueryStringParams + self.queryStringParams

        guard let url = try? urlComponents.asURL() else {
            fatalError("Could not build URL from URLComponents: \(String(describing: urlComponents.string))")
        }

        var request = URLRequest(url: url)
        request.method = self.httpMethod
        return request
    }

}
