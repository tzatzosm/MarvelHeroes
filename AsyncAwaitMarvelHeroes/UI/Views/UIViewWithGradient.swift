//
//  UIViewWithGradient.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation
import UIKit

class UIViewWithGradient: UIView {

    // MARK: - Public properties

    var colors: [CGColor] = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor] {
        didSet {
            gradientLayer.colors = colors
            gradientLayer.needsLayout()
        }
    }

    // MARK: - Private properties

    private var gradientLayer: CAGradientLayer!

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    // MARK: - Configure

    private func configure() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
