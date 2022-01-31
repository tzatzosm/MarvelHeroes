//
//  Thumbnail+URL.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//  Copyright © 2022 QQ. All rights reserved.
//

import Foundation

extension Thumbnail {
    var URI: String {
        let path = path.replacingOccurrences(of: "http", with: "https")
        return "\(path).\(thumbnailExtension)"
    }
}
