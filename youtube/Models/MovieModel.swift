//
//  MovieModel.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import UIKit

struct MovieModel {
    let imagePath: String?
    let title: String?
    let poster: PosterModel?
    let viewsCount: Int?
    let postedAt: Date?

    init(imagePath: String? = nil,
         title: String? = nil,
         poster: PosterModel? = nil,
         viewsCount: Int? = nil,
         postedAt: Date? = nil) {
        self.imagePath = imagePath
        self.title = title
        self.poster = poster
        self.viewsCount = viewsCount
        self.postedAt = postedAt
    }
}

// MARK: - Loadable
extension MovieModel: Loadable {
    var url: String? {
        return self.imagePath
    }
}
