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
    @IBOutlet var homeWinIndicator: UIImageView!
    @IBOutlet var awayWinIndicator: UIImageView!

    var game: Game! {
        didSet {
            setUpCell()
        }
    }

    func setUpCell() {
        switch game.sport.rawValue {
        case "mlb":
            setUpMLBCell()
        case "nfl":
            setUpNFLCell()
        default: ()
        }
    }

    func setUpMLBCell() {
        homeLabel.text = game.homeTeam
        awayLabel.text = game.awayTeam

        switch game.status! {
        case "Scheduled":
            dateLabel.text = game.date?.toGameString()
        case "Final":
            dateLabel.text = "Final"
            if (game.inning?.inning)! > 9 {
                dateLabel.text = "Final / \((game.inning?.inning)!)"
            }
        case "Postponed":
            dateLabel.text = "Postponed"
        default:
            dateLabel.text = "\(game.inning!.half!.toHalfInning()) \(game.inning!.inning!)"
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

        if game.status == "Final" {
            if game.homeScore! > game.awayScore! {
                homeWinIndicator.isHidden = false
                awayWinIndicator.isHidden = true
            } else if game.homeScore! < game.awayScore! {
                homeWinIndicator.isHidden = true
                awayWinIndicator.isHidden = false
            }
        }
    }

    func setUpNFLCell() {
        homeLabel.text = game.homeTeam
        awayLabel.text = game.awayTeam

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

        if game.status == "InProgress" || game.status == "Finished" {
            dateLabel.text = game.quarter
        } else {
            dateLabel.text = game.date?.toGameString()
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

        if game.status == "Finished" {
            if game.homeScore! > game.awayScore! {
                homeWinIndicator.isHidden = false
                awayWinIndicator.isHidden = true
            } else if game.homeScore! < game.awayScore! {
                homeWinIndicator.isHidden = true
                awayWinIndicator.isHidden = false
            }
        }
    }

}
