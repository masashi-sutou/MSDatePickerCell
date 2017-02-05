//
//  ViewController.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/06.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MSDatePickerCell-Demo"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel?.text = "YMD"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "YM"
            } else {
                cell.textLabel?.text = "MD"
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(YMDViewController(), animated: true)
            } else if indexPath.row == 1 {
                self.navigationController?.pushViewController(YMViewController(), animated: true)
            } else {
                self.navigationController?.pushViewController(MDViewController(), animated: true)
            }
        default: break
        }
    }
}
