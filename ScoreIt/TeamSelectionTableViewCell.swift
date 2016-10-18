//
//  TeamSelectionTableViewCell.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/18/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class TeamSelectionTableViewCell: UITableViewCell {

    @IBOutlet var teamLabel: UILabel!

    var team: Team! {
        didSet {
            setUpCell()
        }
    }

    func setUpCell() {
        teamLabel.text = team.city + " " + team.name
    }

}
