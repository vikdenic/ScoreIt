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

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    func getData() {
        //create path
        var path = "https://api.fantasydata.net/mlb/v2/json/Games/2016" as NSString
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
            if let data = data {
                let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print(response)
            }
        }
        task.resume()
    }



}

//int main(int argc, const char * argv[])
//{
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//
//    NSString* path = @"https://api.fantasydata.net/mlb/v2/{format}/teams";
//    NSArray* array = @[
//    // Request parameters
//    @"entities=true",
//    ];
//
//    NSString* string = [array componentsJoinedByString:@"&"];
//    path = [path stringByAppendingFormat:@"?%@", string];
//
//    NSLog(@"%@", path);
//
//    NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
//    [_request setHTTPMethod:@"GET"];
//    // Request headers
//    [_request setValue:@"{subscription key}" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
//    // Request body
//    [_request setHTTPBody:[@"{body}" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
//
//    if (nil != error)
//    {
//        NSLog(@"Error: %@", error);
//    }
//    else
//    {
//        NSError* error = nil;
//        NSMutableDictionary* json = nil;
//        NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", dataString);
//
//        if (nil != _connectionData)
//        {
//            json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
//        }
//
//        if (error || !json)
//        {
//            NSLog(@"Could not parse loaded json with error:%@", error);
//        }
//
//        NSLog(@"%@", json);
//        _connectionData = nil;
//    }
//
//    [pool drain];
//
//    return 0;
//}

