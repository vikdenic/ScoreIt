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

    override func viewDidLoad() {
        super.viewDidLoad()
        SportsData.games(forDate: "2016-OCT-18") { (games, error) in
            guard let games = games else {
                print(error)
                return
            }
            print(games.count)
        }
    }


}

let kMLBPrimaryKey = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!)?.object(forKey: "mlb_primary_key") as! String
let kGamesByDatePath = "https://api.fantasydata.net/mlb/v2/json/GamesByDate/"
let kSchedulesPath = "https://api.fantasydata.net/mlb/v2/json/Games/2016"
let kActiveTeamsPath = "https://api.fantasydata.net/mlb/v2/json/teams"

class SportsData {
    /// Returns a list of Games for the specified date
    ///
    /// - parameter date:     The date to retrieve games for, in the format: 2015-JUL-31
    /// - parameter complete: The completion block of the network call, returning games or an error
    class func games(forDate date: String, complete : @escaping (_ games : [Game]?, _ error: Error?) -> Void) {
        //create path
        var path = kGamesByDatePath + date
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
                    var games = [Game]()
                    for dict in jsonArray {
                        let game = Game(dict: dict)
                        games.append(game)
                        DispatchQueue.main.async {
                            complete(games, error)
                        }
                    }
                }
            } catch {
                complete(nil, error)
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

