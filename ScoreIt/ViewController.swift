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
    @IBOutlet var dateLabel: UILabel!
    let refreshControl = UIRefreshControl()

    var date = NSDate() {
        didSet {
            updateDateLabel()
            retrieveGameData()
        }
    }

    var games = [Game]() {
        didSet {
            self.updateDateLabel()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)

        refreshSetUp()
        updateDateLabel()
        retrieveGameData()
    }

    func updateDateLabel() {
        dateLabel.text = date.toDayString()
    }

    func refreshSetUp() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(retrieveGameData), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }

    func retrieveGameData() {
        SportsData.games(forDate: date.toAPIString()) { (games, error) in
            self.refreshControl.endRefreshing()
            guard let games = games else {
                print(error)
                return
            }
            self.games = games
        }
    }

    @IBAction func onPreviousTapped(_ sender: UIButton) {
        date = date.yesterday()
    }

    @IBAction func onNextTapped(_ sender: UIButton) {
        date = date.tomorrow()
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
                    }
                    DispatchQueue.main.async {
                        complete(games, error)
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
    var status: String?

    init(dict: NSDictionary) {
        self.homeTeam = dict["HomeTeam"] as? String
        self.awayTeam = dict["AwayTeam"] as? String
        self.homeScore = dict["HomeTeamRuns"] as? Int
        self.awayScore = dict["AwayTeamRuns"] as? Int
        self.spread = dict["PointSpread"] as? Float
        self.date = (dict["DateTime"] as? String)?.toDate()
        self.status = dict["Status"] as? String
    }

}

extension NSDate {
    func toGameString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd, h:mm a"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }

    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }
    func toAPIString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }
    func yesterday() -> NSDate {
        return NSCalendar.current.date(byAdding: .day, value: -1, to: self as Date)! as NSDate
    }
    func tomorrow() -> NSDate {
        return NSCalendar.current.date(byAdding: .day, value: 1, to: self as Date)! as NSDate
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

enum GameStatus: String {
    case scheduled
    case final
}
