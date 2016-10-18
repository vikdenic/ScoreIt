//
//  FavoritesTableViewController.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

}

extension FavoritesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}
