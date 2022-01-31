//
//  CharacterCollectionViewCell.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import UIKit
import Nuke
import SwiftUI
import SkeletonView

class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: - Subviews -

    private let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.isSkeletonable = true
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let heroNameLabelBackgroundView: UIView = {
        let view = UIViewWithGradient()
        view.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        return view
    }()

    private let heroNameLabel: UILabel = {
        let label = UILabelWithContentInsets(insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        thumbnailImageView.hideSkeleton()
    }

    // MARK: - Configure -

    private func configure() {
        addSubviews()
        addLayoutConstraints()
    }

    private func addSubviews() {

        [
            thumbnailImageView,
            activityIndicator,
            heroNameLabelBackgroundView,
            heroNameLabel,
        ].forEach { contentView.addSubview($0) }
    }

    private func addLayoutConstraints() {
        [
            thumbnailImageView,
            activityIndicator,
            heroNameLabelBackgroundView,
            heroNameLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            heroNameLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroNameLabelBackgroundView.topAnchor.constraint(equalTo: heroNameLabel.topAnchor),
            heroNameLabelBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroNameLabelBackgroundView.bottomAnchor.constraint(equalTo: heroNameLabel.bottomAnchor),

            heroNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // MARK: - Load data -

    func load(_ data: CharacterData) {
        heroNameLabel.text = data.name
        if let url = URL(string: data.thumbnail.URI) {
            activityIndicator.startAnimating()
            Nuke.loadImage(with: url, into: thumbnailImageView) { [weak self] _ in
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    func startAnimating() {
        thumbnailImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .wetAsphalt, secondaryColor: .clouds), transition: .crossDissolve(0.4))
    }
}
