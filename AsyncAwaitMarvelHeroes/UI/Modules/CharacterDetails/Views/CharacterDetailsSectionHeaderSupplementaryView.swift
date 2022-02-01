//
//  CharacterDetailsSectionHeaderSupplementaryView.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 01/02/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation
import UIKit

final class CharacterDetailsSectionHeaderSupplementaryView: UICollectionReusableView {

    // MARK: - Subviews -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure -

    private func configure() {
        addSubviews()
        addLayoutConstraints()
    }

    private func addSubviews() {
        [
            titleLabel
        ].forEach { addSubview($0) }
    }

    private func addLayoutConstraints() {
        [
            titleLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Load data -

    func setTitle(_ title: String) {
        titleLabel.text = title
    }


}
