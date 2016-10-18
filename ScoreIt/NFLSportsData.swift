//
//  NFLSportsData.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/18/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import Foundation

let kNFLPrimaryKey = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!)?.object(forKey: "nfl_primary_key") as! String

let kNFLCurrentWeekPath = "https://api.fantasydata.net/v3/nfl/scores/json/CurrentWeek"
let kNFLActiveTeamsPath = "https://api.fantasydata.net/v3/nfl/scores/json/Teams"
let kNFLScoresByWeek = "https://api.fantasydata.net/v3/nfl/scores/json/ScoresByWeek/2016/"
let kNFLStandingsPath = "https://api.fantasydata.net/v3/nfl/scores/json/Standings/2016"

class NFLSportsData {
    /// Returns a list of Games for the specified date
    ///
    /// - parameter date:     The date to retrieve games for, in the format: 2015-JUL-31
    /// - parameter complete: The completion block of the network call, returning games or an error
    class func games(forWeek week: Int, complete : @escaping (_ games : [Game]?, _ error: Error?) -> Void) {
        //create path
        var path = kNFLScoresByWeek + String(week)
        let params = ["entities=true"] as NSArray

        let string = params.componentsJoined(by: "&")
        path = path.appendingFormat("?%@", string)

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let request = NSMutableURLRequest(url: NSURL(string: path as String)! as URL)
        request.httpMethod = "GET"
        // Request headers
        request.setValue(kNFLPrimaryKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            do {
                if let data = data {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [NSDictionary]
                    var games = [Game]()
                    for dict in jsonArray {
                        print(dict)
                        let game = Game(dict: dict, sport: .nfl)
                        game.sport = .nfl
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
        var path = kNFLActiveTeamsPath
        let params = ["entities=true"] as NSArray

        let string = params.componentsJoined(by: "&")
        path = path.appendingFormat("?%@", string)

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let request = NSMutableURLRequest(url: NSURL(string: path as String)! as URL)
        request.httpMethod = "GET"
        // Request headers
        request.setValue(kNFLPrimaryKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

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
        var path = kNFLStandingsPath
        let params = ["entities=true"] as NSArray

        let string = params.componentsJoined(by: "&")
        path = path.appendingFormat("?%@", string)

        let session = URLSession(configuration: URLSessionConfiguration.default)

        let request = NSMutableURLRequest(url: NSURL(string: path as String)! as URL)
        request.httpMethod = "GET"
        // Request headers
        request.setValue(kNFLPrimaryKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

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
