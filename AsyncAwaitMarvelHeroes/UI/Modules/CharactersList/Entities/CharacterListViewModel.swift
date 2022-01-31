//
//  CharacterListViewModel.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation

struct CharactersListViewModel {

    enum SectionIdentifier: Int {
        case heroes
        case loading
    }

    struct Section: Hashable {
        let sectionIdentifier: SectionIdentifier
        let items: [Item]
    }

    enum Item: Hashable {
        case characterLoading(index: Int)
        case character(data: CharacterData)
        case loadingNextPage

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .character(data):
                hasher.combine(data.id)
            case let .characterLoading(index):
                hasher.combine(index)
            case .loadingNextPage:
                hasher.combine("HeroesListViewModel.Item.LoadingNextPage")
            }
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
            case let (.characterLoading(lIndex), .characterLoading(rIndex)):
                return lIndex == rIndex
            case let (.character(lData), .character(rData)):
                return lData.id == rData.id
            case (.loadingNextPage, .loadingNextPage):
                return true

            default:
                return false
            }
        }
    }
}
