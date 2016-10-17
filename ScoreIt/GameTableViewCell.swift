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

    var game: Game! {
        didSet {
            setUpCell()
        }
    }

    func setUpCell() {
        homeLabel.text = game.homeTeam
        awayLabel.text = game.awayTeam
        dateLabel.text = game.date?.toAbbrevString()
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
