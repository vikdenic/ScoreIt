//
//  TeamSelectionViewController.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/18/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class TeamSelectionViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var sport: Sport!

    var teams = [Team]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveTeams()
    }

    func retrieveTeams() {
        switch sport.rawValue {
        case "mlb":
            MLBSportsData.teams { (teams, error) in
                guard let teams = teams else {
                    print(error)
                    return
                }
                self.teams = teams
            }
        case "nfl":
            NFLSportsData.teams { (teams, error) in
                guard let teams = teams else {
                    print(error)
                    return
                }
                self.teams = teams
            }
        default: ()
        }
    }

}

extension TeamSelectionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! TeamSelectionTableViewCell
        cell.team = teams[indexPath.row]
        return cell
    }
}
