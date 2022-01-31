//
//  LoadingCollectionViewCell.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation
import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

    // MARK: - Subviews

    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private let loadingNextLabel: UILabel = {
        let label = UILabelWithContentInsets(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 10)
        label.text = "loading next page"
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    // MARK: - Configure

    private func configure() {
        addSubviews()
        addLayoutConstraints()
    }

    private func addSubviews() {
        [
            loadingIndicator,
            loadingNextLabel
        ].forEach { contentView.addSubview($0) }
    }

    private func addLayoutConstraints() {
        [
            loadingIndicator,
            loadingNextLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            loadingNextLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor),
            loadingNextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingNextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func startAnimating() {
        loadingIndicator.startAnimating()
    }
}
