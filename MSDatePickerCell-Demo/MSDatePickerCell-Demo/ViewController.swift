//
//  ViewController.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/06.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    public var birthday: Birthday?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.birthday = Birthday()
        
        self.navigationItem.title = "MSDatePickerCell-Demo"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
                cell.detailTextLabel?.text = self.birthday?.ymdDate?.string(format: NSLocalizedString("MMMM d, yyyy", comment: ""))
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "YM"
                cell.detailTextLabel?.text = self.birthday?.ymDate?.string(format: NSLocalizedString("MMMM, yyyy", comment: ""))
            } else {
                cell.textLabel?.text = "MD"
                cell.detailTextLabel?.text = self.birthday?.mdDate?.string(format: NSLocalizedString("MMMM d", comment: ""))
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
                self.navigationController?.pushViewController(YMDViewController.init(birthday: self.birthday!), animated: true)
            } else if indexPath.row == 1 {
                self.navigationController?.pushViewController(YMViewController.init(birthday: self.birthday!), animated: true)
            } else {
                self.navigationController?.pushViewController(MDViewController.init(birthday: self.birthday!), animated: true)
            }
        default: break
        }
    }
}
