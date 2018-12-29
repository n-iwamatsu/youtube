//
//  PosterModel.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import UIKit

struct PosterModel {
    let imagePath: String?
    let name: String?

    init(imagePath: String? = nil, name: String? = nil) {
        self.imagePath = imagePath
        self.name = name
    }
}

// MARK: - Loadable
extension PosterModel: Loadable {
    var url: String? {
        return self.imagePath
    }
}
