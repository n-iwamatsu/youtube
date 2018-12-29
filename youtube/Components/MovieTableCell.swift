//
//  MovieTableCell.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func setModel(_ model: MovieModel) {
        self.movieImage.loadImage(model)
        self.posterImage.circle().loadImage(model.poster)

        self.titleLabel.text = model.title
        self.descriptionLabel.text = self.createDescription(model)
    }

    private func createDescription(_ model: MovieModel) -> String {
        var description = (model.poster?.name ?? "")
        description += "・" + ((model.viewsCount ?? 0).separate ?? "") + " views"
        description += "・" + (model.postedAt?.string ?? "")
        return description
    }
}

// MARK: - Designable
extension MovieTableCell: Designable { }
