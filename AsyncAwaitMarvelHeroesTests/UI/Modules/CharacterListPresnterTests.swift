//
//  CharacterListPresnterTests.swift
//  AsyncAwaitMarvelHeroesTests
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import XCTest
@testable import AsyncAwaitMarvelHeroes

class CharacterListPresnterTests: XCTestCase {

    private var sut: CharactersListPresenter!
    private var interactor: MockCharactersListInteractor!
    private var view: MockCharactersListView!
    private var wireframe: MockCharactersListWireframe!


    // MARK: - Mocks -

    private final class MockCharactersListInteractor: CharactersListInteractorInterface {
        var service: MockMarvelService = MockMarvelService(total: 1)

        private(set) var offset: Int? = nil
        private(set) var searchTerm: String? = nil
        private(set) var searchIsCalled = false
        func search(for term: String?, offset: Int, limit: Int) async throws -> CharactersResponseData {
            self.searchTerm = term
            self.offset = offset
            self.searchIsCalled = true
            return try await service.getCharacters(nameStartsWith: nil, order: "", offset: 0, limit: 1).data
        }
    }

    private final class MockCharactersListView: CharactersListViewInterface {
        private(set) var clearResultsIsCalled = false
        func clearResults() {
            clearResultsIsCalled = true
        }

        private(set) var sections = [[CharactersListViewModel.Section]]()
        private(set) var showResultsCalledCount = 0
        func showResults(sections: [CharactersListViewModel.Section]) {
            showResultsCalledCount += 1
            self.sections.append(sections)
        }
    }

    private final class MockCharactersListWireframe: CharactersListWireframeInterface {

        private(set) var navigateToCharacterDetailsIsCalled = false
        func navigateToCharacterDetails(character: CharacterData) {
            navigateToCharacterDetailsIsCalled = true
        }

    }

    // MARK: - Setup -

    override func setUpWithError() throws {
        interactor = MockCharactersListInteractor()
        view = MockCharactersListView()
        wireframe = MockCharactersListWireframe()
        sut = CharactersListPresenter(view: view, interactor: interactor, wireframe: wireframe)
    }

    // MARK: - Tests -

    func test_search_termIsNil_interactorSearchIsCalled() async throws {
        // when
        await sut.search(for: nil)

        // Then
        XCTAssertTrue(interactor.searchIsCalled)
        XCTAssertEqual(interactor.searchTerm, nil)
        XCTAssertEqual(interactor.offset, 0)
    }

    func test_search_resultIsReturned_totalIsEqualToResultsCount_viewShowResultsIsCalledTwiceAndLoadingMoreIsHidden() async throws {
        // when
        await sut.search(for: nil)

        // Then
        XCTAssertEqual(view.showResultsCalledCount, 2)
        let characterData = try await interactor.service.getCharacters(nameStartsWith: "", order: "", offset: 0, limit: 1).data.results!.first!
        XCTAssertEqual(view.sections, [
            [
                .init(sectionIdentifier: .heroes, items: (0..<10).map { .characterLoading(index: $0) })
            ],
            [
                .init(sectionIdentifier: .heroes, items: [.character(data: characterData)])
            ],
        ])
        XCTAssertEqual(interactor.offset, 0)
    }

    func test_search_resultIsReturned_totalIsLessThanResultsCount_viewShowResultsIsCalledTwiceAndLoadingMoreIsVisible() async throws {
        // Given
        interactor.service = MockMarvelService(total: 2)

        // When
        await sut.search(for: nil)

        // Then
        XCTAssertEqual(view.showResultsCalledCount, 2)
        let characterData = try await interactor.service.getCharacters(nameStartsWith: "", order: "", offset: 0, limit: 1).data.results!.first!
        XCTAssertEqual(view.sections[0], [.init(sectionIdentifier: .heroes, items: (0..<10).map { .characterLoading(index: $0) })])
        XCTAssertEqual(view.sections[1], [
            .init(sectionIdentifier: .heroes, items: [.character(data: characterData)]),
            .init(sectionIdentifier: .loading, items: [.loadingNextPage])
        ])
    }

    func test_searchAndLoadNextPage_totalIsEqualToResultsCount_viewShowResultsIsCalledThreeTimeAndLoadingMoreIsHidden() async throws {
        // Given
        interactor.service = MockMarvelService(total: 2)

        // When
        await sut.search(for: nil)
        await sut.loadNextPage()

        // Then
        XCTAssertEqual(view.showResultsCalledCount, 3)
        let characterData = try await interactor.service.getCharacters(nameStartsWith: "", order: "", offset: 0, limit: 1).data.results!.first!
        XCTAssertEqual(view.sections[0], [.init(sectionIdentifier: .heroes, items: (0..<10).map { .characterLoading(index: $0) })])
        XCTAssertEqual(view.sections[1], [
            .init(sectionIdentifier: .heroes, items: [.character(data: characterData)]),
            .init(sectionIdentifier: .loading, items: [.loadingNextPage])
        ])
        XCTAssertEqual(view.sections[2], [
            .init(sectionIdentifier: .heroes, items: [.character(data: characterData), .character(data: characterData)]),
        ])
    }

    func test_search_afterLoadNextPageMultipleTimes_resultsAreCleared() async throws {
        // Given
        interactor.service = MockMarvelService(total: 2)

        // When
        await sut.search(for: nil)
        await sut.loadNextPage()
        await sut.loadNextPage()
        await sut.loadNextPage()
        await sut.loadNextPage()
        await sut.search(for: nil)

        // Then
        let characterData = try await interactor.service.getCharacters(nameStartsWith: "", order: "", offset: 0, limit: 1).data.results!.first!
        XCTAssertEqual(view.sections.last!, [
            .init(sectionIdentifier: .heroes, items: [.character(data: characterData)]),
            .init(sectionIdentifier: .loading, items: [.loadingNextPage])
        ])
    }

    // TODO: Investigate a bit what can be done here
//    func test_searchAndLoadNextPageMultiple_thenLoadNextPageIsOnlyExecutedOnce() async throws {
//        // Given
//        interactor.service = MockMarvelService(total: 2)
//
//        // When
//        await sut.search(for: nil)
//        async let nextPage1: () = await self.sut.loadNextPage()
//        async let nextPage2: () = await self.sut.loadNextPage()
//        _ = await [nextPage1, nextPage2]
//
//        // Then
//        XCTAssertEqual(view.showResultsCalledCount, 3)
//    }

    func text_whenCharacterIsSelected_thenWireframeNavigateToCharacterDetailsIsCalled() async {
        // Given
        let characterData = try! await interactor.service.getCharacters(nameStartsWith: nil, order: "", offset: 0, limit: 1).data.results!.first!

        // When
        sut.didSelect(character: characterData)

        // Then
        XCTAssertTrue(wireframe.navigateToCharacterDetailsIsCalled)
    }

}
