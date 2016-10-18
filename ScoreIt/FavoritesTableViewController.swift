//
//  FavoritesTableViewController.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    var selectedSport: Sport?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sportsToTeams" {
            if let sport = selectedSport {
                let teamsVC = segue.destination as! TeamSelectionViewController
                teamsVC.sport = sport
            }
        }
    }

}

extension FavoritesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: selectedSport = .mlb
        case 1: selectedSport = .nfl
        default: ()
        }
        performSegue(withIdentifier: "sportsToTeams", sender: nil)
    }

}
