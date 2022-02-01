//
//  CharacterThumbnailCollectionViewCell.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import UIKit
import Nuke

class CharacterDetailsThumbnailCollectionViewCell: UICollectionViewCell {
    // MARK: - Subviews

    private let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
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
        contentView.addSubview(thumbnailImageView)
    }

    private func addLayoutConstraints() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
        ])
    }

    // MARK: - Load data

    func load(_ imageUrl: String) {
        if let url = URL(string: imageUrl) {
            Nuke.loadImage(with: url, into: thumbnailImageView)
        }
    }
}
