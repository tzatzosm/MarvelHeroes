//
//  UILabelWithContentInsets.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation
import UIKit

class UILabelWithContentInsets: UILabel {
    // MARK: - Public Properties

    var insets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Init

    convenience init(insets: UIEdgeInsets) {
        self.init(frame: .zero)
        self.insets = insets
    }

    override init(frame: CGRect) {
        self.insets = .zero
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
    }

}
