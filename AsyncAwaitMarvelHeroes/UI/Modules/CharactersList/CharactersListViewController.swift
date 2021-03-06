//
//  CharactersListViewController.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright (c) 2022 QQ. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class CharactersListViewController: UICollectionViewController {

    // MARK: - Typealias

    private typealias DataSource = UICollectionViewDiffableDataSource<CharactersListViewModel.Section, CharactersListViewModel.Item>
    private typealias CharacterCellRegistraction = UICollectionView.CellRegistration<CharacterCollectionViewCell, CharactersListViewModel.Item>
    private typealias LoadingCellRegistration = UICollectionView.CellRegistration<LoadingCollectionViewCell, CharactersListViewModel.Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<CharactersListViewModel.Section, CharactersListViewModel.Item>

    // MARK: - Public properties -

    var presenter: CharactersListPresenterInterface!

    // MARK: - Private properties -

    private var dataSource: DataSource?

    private let characterCellRegistration = CharacterCellRegistraction { (cell: CharacterCollectionViewCell, _: IndexPath, data: CharactersListViewModel.Item) in
        if case let .character(data) = data {
            cell.load(data)
        } else {
            cell.startAnimating()
        }
    }

    private let loadingCellRegistration = LoadingCellRegistration { (cell: LoadingCollectionViewCell, _, _) in cell.startAnimating() }

    // MARK: - Subviews -

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Initialization -

    init() {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = CharactersListViewModel.SectionIdentifier(rawValue: sectionIndex) else { return nil }

            let itemWidthDimension: NSCollectionLayoutDimension
            let groupHeightDimension: NSCollectionLayoutDimension
            switch sectionIdentifier {
            case .heroes:
                let fraction: CGFloat = 1/2
                itemWidthDimension = .fractionalWidth(fraction)
                groupHeightDimension = .fractionalWidth(fraction)
            case .loading:
                itemWidthDimension = .fractionalWidth(1)
                groupHeightDimension = .estimated(100)
            }
            let inset: CGFloat = 2.5
            let insets: NSDirectionalEdgeInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)

            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: itemWidthDimension,
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = insets

            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: groupHeightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = insets

            return section
        }
        super.init(collectionViewLayout: compositionalLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        Task.detached {
            await self.presenter.search(for: nil)
        }
    }

}

// MARK: - UICollectionViewDelegate -

extension CharactersListViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if case .loadingNextPage = dataSource?.itemIdentifier(for: indexPath) {
            Task.detached {
                await self.presenter.loadNextPage()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case let .character(data) = dataSource?.itemIdentifier(for: indexPath) {
            presenter.didSelect(character: data)
        }
    }
}


// MARK: - Configuration -

private extension CharactersListViewController {
    func configure() {
        title = "Marvel Heroes"
        configureSearchController()
        configureCollectionView()
    }

    func configureSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            switch item {
            case .character:
                return collectionView.dequeueConfiguredReusableCell(using: self.characterCellRegistration, for: indexPath, item: item)
            case .characterLoading:
                return collectionView.dequeueConfiguredReusableCell(using: self.characterCellRegistration, for: indexPath, item: item)
            case .loadingNextPage:
                return collectionView.dequeueConfiguredReusableCell(using: self.loadingCellRegistration, for: indexPath, item: item)
            }
        })
    }
}

// MARK: - SearchBarDelegate -

extension CharactersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task.detached {
            await self.presenter.search(for: searchBar.text)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Task.detached {
            await self.presenter.search(for: nil)
        }
    }
}


// MARK: - CharactersListViewInterface -
extension CharactersListViewController: CharactersListViewInterface {

    func clearResults() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        dataSource?.apply(snapshot)
    }

    func showResults(sections: [CharactersListViewModel.Section]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func clearError() {
        self.collectionView.backgroundView = nil
    }

    func showError(errorMessage: String) {
        let errorView = UIView()

        let label = UILabel()
        label.text = errorMessage
        label.numberOfLines = 0
        label.textAlignment = .center

        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = "Retry"
        let action = UIAction { action in
            Task.detached {
                await self.presenter.search(for: nil)
            }
        }
        let retryButton = UIButton(configuration: buttonConfiguration, primaryAction: action)
        [label, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            errorView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: errorView.centerYAnchor, constant: -4),
            label.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: errorView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: errorView.trailingAnchor, constant: -16),

            retryButton.topAnchor.constraint(equalTo: errorView.centerYAnchor, constant: 4),
            retryButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
        ])
        self.collectionView.backgroundView = errorView
    }

}
