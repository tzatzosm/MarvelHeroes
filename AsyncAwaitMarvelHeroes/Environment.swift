//
//  File.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//

import Foundation

struct Environment {

    static let current = Environment()

    let publicApiKey: String
    let privateApiKey: String

    fileprivate init() {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let keysDictionary = NSDictionary(contentsOfFile: path),
              let publicApiKey = keysDictionary["public_key"] as? String, !publicApiKey.isEmpty,
              let privateApiKey = keysDictionary["private_key"] as? String, !privateApiKey.isEmpty else {
                fatalError("APIKeys.plist is missing or api keys not defined.")
        }
        self.publicApiKey = publicApiKey
        self.privateApiKey = privateApiKey
    }

}
