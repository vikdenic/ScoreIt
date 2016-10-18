//
//  GameTableViewCell.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var homeLabel: UILabel!
    @IBOutlet var awayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var spreadLabel: UILabel!
    @IBOutlet var homeScoreLabel: UILabel!
    @IBOutlet var awayScoreLabel: UILabel!

    var game: Game! {
        didSet {
            setUpCell()
        }
    }

    func setUpCell() {
        homeLabel.text = game.homeTeam
        awayLabel.text = game.awayTeam

        switch game.status! {
        case "Final":
            dateLabel.text = "Final"
        default:
            dateLabel.text = game.date?.toGameString()
        }

        if let homeScore = game.homeScore {
            homeScoreLabel.text = "\(homeScore)"
        } else {
            homeScoreLabel.text = ""
        }

        if let awayScore = game.awayScore {
            awayScoreLabel.text = "\(awayScore)"
        } else {
            awayScoreLabel.text = ""
        }

        if let spread = game.spread {
            if spread < 0 {
                spreadLabel.text = "\(game.homeTeam!) \(spread)"
            } else {
                spreadLabel.text = "\(game.homeTeam!) +\(spread)"
            }
        } else {
            spreadLabel.text = ""
        }
    }

}
