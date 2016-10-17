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
        dateLabel.text = game.date?.toAbbrevString()

        if let homeScore = game.homeScore {
            homeScoreLabel.text = "\(homeScore)"
        }

        if let awayScore = game.awayScore {
            awayScoreLabel.text = "\(awayScore)"
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
