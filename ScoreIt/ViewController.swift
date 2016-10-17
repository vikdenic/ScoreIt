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

    var games = [Game]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        retrieveGameData()
    }

    func retrieveGameData() {
        SportsData.games(forDate: "2016-OCT-18") { (games, error) in
            guard let games = games else {
                print(error)
                return
            }
            self.games = games
        }
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
                        print(dict)
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
    var spread: Float?
    var date: NSDate?

    init(dict: NSDictionary) {
        self.homeTeam = dict["HomeTeam"] as? String
        self.awayTeam = dict["AwayTeam"] as? String
        self.homeScore = dict["HomeTeamRuns"] as? Int
        self.awayScore = dict["AwayTeamRuns"] as? Int
        self.spread = dict["PointSpread"] as? Float
        self.date = (dict["DateTime"] as? String)?.toDate()
    }

}

extension NSDate {
    func toAbbrevString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd, h:mm a"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }
}

extension String {
    func toDate() -> NSDate {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let est = NSTimeZone(abbreviation: "EST")
        formatter.timeZone = est as TimeZone!
        return formatter.date(from: self)! as NSDate
    }
}

