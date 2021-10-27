//
//  ViewController.swift
//  多列表联动
//
//  Created by AlbertYuan on 2021/10/27.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {

        }else if indexPath.row == 1 {
            navigationController?.pushViewController(TableAndCollectionVc(), animated: true)
        }else{
            navigationController?.pushViewController(NaviTestViewController(), animated: true)
        }
    }
}

