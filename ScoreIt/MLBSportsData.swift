//
//  Model.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/18/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import Foundation

let kMLBPrimaryKey = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!)?.object(forKey: "mlb_primary_key") as! String
let kMLBGamesByDatePath = "https://api.fantasydata.net/mlb/v2/json/GamesByDate/"
let kMLBSchedulesPath = "https://api.fantasydata.net/mlb/v2/json/Games/2016"
let kMLBActiveTeamsPath = "https://api.fantasydata.net/mlb/v2/json/teams"
let kMLBStandingsPath = "https://api.fantasydata.net/mlb/v2/json/Standings/2016"

class MLBSportsData {
    /// Returns a list of Games for the specified date
    ///
    /// - parameter date:     The date to retrieve games for, in the format: 2015-JUL-31
    /// - parameter complete: The completion block of the network call, returning games or an error
    class func games(forDate date: String, complete : @escaping (_ games : [Game]?, _ error: Error?) -> Void) {
        //create path
        var path = kMLBGamesByDatePath + date
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
                        let game = Game(dict: dict, sport: .mlb)
                        game.sport = .mlb
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

    /// Returns a list of active MLB Teams
    ///
    /// - parameter complete: The completion block of the network call, returning teams or an error
    class func teams(complete : @escaping (_ teams : [Team]?, _ error: Error?) -> Void) {
        //create path
        var path = kMLBActiveTeamsPath
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
                    var teams = [Team]()
                    for dict in jsonArray {
                        print(dict)
                        let team = Team(dict: dict)
                        teams.append(team)
                    }
                    DispatchQueue.main.async {
                        complete(teams, error)
                    }
                }
            } catch {
                complete(nil, error)
            }
        }
        task.resume()
    }

    /// Returns a list of active MLB Teams
    ///
    /// - parameter complete: The completion block of the network call, returning teams or an error
    class func standings(complete : @escaping (_ teams : [Team]?, _ error: Error?) -> Void) {
        //create path
        var path = kMLBStandingsPath
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
//                    var teams = [Team]()
                    for dict in jsonArray {
                        print(dict)
//                        let team = Team(dict: dict)
//                        teams.append(team)
                    }
                    DispatchQueue.main.async {
//                        complete(teams, error)
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
    var sport: Sport!
    var homeTeam: String?
    var awayTeam: String?
    var homeScore: Int?
    var awayScore: Int?
    var spread: Float?
    var date: NSDate?
    var status: String? = "Scheduled" //mlb & nfl
    var inning : (inning: Int?, half: String?)? //mlb
    var quarter: String? //nfl

    init(dict: NSDictionary, sport: Sport) {
        self.homeTeam = dict["HomeTeam"] as? String
        self.awayTeam = dict["AwayTeam"] as? String
        self.spread = dict["PointSpread"] as? Float

        //Sport-specific properties
        switch sport.rawValue {
        case "mlb":
            self.date = (dict["DateTime"] as? String)?.toDate()
            self.status = dict["Status"] as? String
            self.homeScore = dict["HomeTeamRuns"] as? Int
            self.awayScore = dict["AwayTeamRuns"] as? Int
            self.inning = (dict["Inning"] as? Int, dict["InningHalf"] as? String)
        case "nfl":
            self.date = (dict["Date"] as? String)?.toDate()
            self.homeScore = dict["HomeScore"] as? Int
            self.awayScore = dict["AwayScore"] as? Int
            self.quarter = dict["Quarter"] as? String

            if dict["isInProgress"] as? Int == 1 {
                self.status = "InProgress"
            }

            if dict["IsOver"] as? Int == 1 {
                self.status = "Finished"
            }

            if dict["Canceled"] as? Int == 1 {
                self.status = "Canceled"
            }

        default: ()
        }
    }
    
}

class Team {
    var name: String!
    var city: String!
    var shortName: String!

    init(dict: NSDictionary) {
        self.city = dict["City"] as! String
        self.name = dict["Name"] as! String
        self.shortName = dict["Key"] as! String
    }

}
