//
//  ViewController.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    let refreshControl = UIRefreshControl()

    var date = NSDate() {
        didSet {
            updateDateLabel()
            retrieveGameData()
        }
    }

    var games = [Game]() {
        didSet {
            self.updateDateLabel()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        refreshSetUp()
        updateDateLabel()
        retrieveGameData()
    }

    func updateDateLabel() {
        dateLabel.text = date.toDayString()
    }

    func refreshSetUp() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(retrieveGameData), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }

    func retrieveGameData() {
        MLBSportsData.games(forDate: date.toAPIString()) { (games, error) in
            self.refreshControl.endRefreshing()
            guard let games = games else {
                print(error)
                return
            }
            self.games = games
        }
    }

    @IBAction func onPreviousTapped(_ sender: UIButton) {
        date = date.yesterday()
    }

    @IBAction func onNextTapped(_ sender: UIButton) {
        date = date.tomorrow()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameTableViewCell
        cell.game = games[indexPath.row]
        return cell
    }
}
