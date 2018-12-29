//
//  HomeViewController.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import Hydra
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.register(MovieTableCell.nib, forCellReuseIdentifier: MovieTableCell.className)
            self.tableView.estimatedRowHeight = 298
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.refreshControl = UIRefreshControl()
            self.tableView.refreshControl?.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
            self.tableView.tableFooterView = UIView()
        }
    }

    let posterImage = "https://raw.githubusercontent.com/nainai0722/youtubeLikeSample0001/master/youtubeLikeSample0001/youtubeLikeSample0001/image/icon.jpeg"
    let movieImage = "https://raw.githubusercontent.com/nainai0722/youtubeLikeSample0001/master/youtubeLikeSample0001/youtubeLikeSample0001/image/test.jpeg"

    let loadCount = 20

    var models: [MovieModel] = []
    var loading = false
    private var rowHeights: [String: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }

    @objc func refreshTableView(_ refreshControl: UIRefreshControl) {
        self.models = []
        load(refreshControl: refreshControl)
    }

    private func load(refreshControl: UIRefreshControl? = nil) {
        guard !self.loading else {
            refreshControl?.endRefreshing()
            return
        }
        self.loading = true
        loadAsync().then { models in
            DispatchQueue.main.async {
                self.loading = false
                refreshControl?.endRefreshing()
                
                self.models.append(contentsOf: models)
                self.tableView.reloadData()
            }
            }.catch { err in
        }
    }

    private func loadAsync() -> Promise<[MovieModel]> {
        return Promise<[MovieModel]>(in: .background, token: nil) { [unowned self] resolve, reject, _ in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: Date())
            let date = calendar.date(from: components)!
            var models: [MovieModel] = []
            for _ in 0..<self.loadCount {
                let count = self.models.count + models.count
                models.append(MovieModel(
                    imagePath: self.movieImage,
                    title: "タイトル",
                    poster: PosterModel(
                        imagePath: self.posterImage,
                        name: "名前"
                    ),
                    viewsCount: count,
                    postedAt: calendar.date(byAdding: .day, value: -count, to: date)
                ))
            }
            resolve(models)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.movieTableCell(tableView, for: indexPath)
    }

    private func movieTableCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableCell.className, for: indexPath) as? MovieTableCell else {
            fatalError("MovieTableView is not registered in tableView.")
        }
        cell.setModel(self.models[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeights[indexPath.string] ?? tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.updateConstraints()
        self.rowHeights[indexPath.string] = cell.frame.size.height
        if models.count % loadCount == 0 && indexPath.row + 1 >= models.count {
            load()
        }
    }
}

// MARK: - IndexPath
private extension IndexPath {
    var string: String {
        return "(\(self.section), \(self.row))"
    }
}
