//
//  CharacterDetailsComicsCollectionViewCell.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import UIKit
import Nuke

class CharacterDetailsComicsCollectionViewCell: UICollectionViewCell {
    // MARK: - Subviews -

    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    private let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.isSkeletonable = true
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
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
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        self.activityIndicatorView.stopAnimating()
    }

    // MARK: - Configure -

    private func configure() {
        contentView.isSkeletonable = true
        addSubviews()
        addLayoutConstraints()
    }

    private func addSubviews() {
        [
            thumbnailImageView,
            activityIndicatorView
        ].forEach { contentView.addSubview($0) }
    }

    private func addLayoutConstraints() {
        [
            thumbnailImageView,
            activityIndicatorView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // MARK: - Load data -

    func load(_ data: ComicData) {
        guard let url = URL(string: data.thumbnail.URI) else { return }
        activityIndicatorView.startAnimating()
        Nuke.loadImage(with: url, into: thumbnailImageView) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
        }
    }

    func startAnimating() {
        contentView.showAnimatedGradientSkeleton()
    }
}
