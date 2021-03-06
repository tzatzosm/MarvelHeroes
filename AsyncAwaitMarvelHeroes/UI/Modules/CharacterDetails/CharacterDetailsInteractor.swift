//
//  CharacterDetailsInteractor.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright (c) 2022 QQ. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation


final class CharacterDetailsInteractor {
    private let marvelService: MarvelServiceInterface

    init(marvelService: MarvelServiceInterface) {
        self.marvelService = marvelService
    }
}

// MARK: - Extensions -

extension CharacterDetailsInteractor: CharacterDetailsInteractorInterface {

    func getComics(characterId: Int) async throws -> [ComicData] {
        return try await marvelService.getComics(for: [characterId]).data.results
    }
}
