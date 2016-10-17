//
//  ViewController.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var awayLabel: UILabel!
    @IBOutlet var homeLabel: UILabel!

    let kMLBPrimaryKey = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!)?.object(forKey: "mlb_primary_key") as! String
    let kGamesByDatePath = "https://api.fantasydata.net/mlb/v2/json/GamesByDate/2016-OCT-16"
    let kSchedulesPath = "https://api.fantasydata.net/mlb/v2/json/Games/2016"
    let kActiveTeamsPath = "https://api.fantasydata.net/mlb/v2/json/teams"

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    func getData() {
        //create path
        var path = kGamesByDatePath as NSString
        let params = ["entities=true"] as NSArray

        let string = params.componentsJoined(by: "&")
        path = path.appendingFormat("?%@", string)
        print(path)

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let request = NSMutableURLRequest(url: NSURL(string: path as String)! as URL)
        request.httpMethod = "GET"
        // Request headers
        request.setValue(kMLBPrimaryKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                do {
                    if let data = data {
                        let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [NSDictionary]
                        for dict in jsonArray {
                            print(dict)
                            DispatchQueue.main.async {
                                let game = Game(dict: dict)
                                self.homeLabel.text = game.homeTeam! + " \(game.homeScore!)"
                                self.awayLabel.text = game.awayTeam! + " \(game.awayScore!)"
                            }
                        }
                    }
                } catch {

                }
        }
        task.resume()
    }


}

class Game {
    var homeTeam: String?
    var awayTeam: String?
    var homeScore: Int?
    var awayScore: Int?
    var spread: String?

    init(dict: NSDictionary) {
        self.homeTeam = dict["HomeTeam"] as? String
        self.awayTeam = dict["AwayTeam"] as? String
        self.homeScore = dict["HomeTeamRuns"] as? Int
        self.awayScore = dict["AwayTeamRuns"] as? Int
        self.spread = dict["PointSpread"] as? String
    }

}

