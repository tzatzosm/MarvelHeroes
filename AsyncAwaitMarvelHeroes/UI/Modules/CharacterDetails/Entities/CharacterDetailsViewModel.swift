//
//  CharacterDetailsViewModel.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation

struct CharacterDetailsViewModel {

    enum SectionIdentifier: Int {
        case header
        case comics
    }

    struct Section {
        let sectionIdentifier: SectionIdentifier
        let items: [Item]
    }

    enum Item: Hashable {
        case thumbnail(imageUrl: String)
        case description(text: String?)
        case comic(data: ComicData)
        case comicsLoading(index: Int)

        func hash(into hasher: inout Hasher) {
            switch self {
            case .thumbnail:
                hasher.combine("HeroDetailsViewModel.Item.thumbnail")
            case .description:
                hasher.combine("HeroDetailsViewModel.Item.description")
            case let .comic(data):
                hasher.combine(data.id)
            case let .comicsLoading(index):
                hasher.combine("HeroDetailsViewModel.Item.comicsLoading-\(index)")
            }
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
            case let (.thumbnail(lImageUrl), .thumbnail(rImageUrl)):
                return lImageUrl == rImageUrl
            case let (.description(lText), .description(rText)):
                return lText == rText
            case let (.comic(lData), .comic(rData)):
                return lData.id == rData.id
            case let (.comicsLoading(lIndex), .comicsLoading(rIndex)):
                return lIndex == rIndex
            default:
                return false
            }
        }
    }
}
