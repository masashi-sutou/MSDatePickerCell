//
//  ViewController.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/04.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

private extension UIColor {
    static func tint() -> UIColor {
        return UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
}

private extension Date {
    func string(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class ViewController: UITableViewController {

    var birthday: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MSDatePickerCell-Demo"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:

            if indexPath.row == 0 {
                
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
                cell.textLabel?.text = "誕生日"

                if let birthday = self.birthday {

                    cell.detailTextLabel?.text = birthday.string(format: "yyyy年MM月dd日")
                    cell.detailTextLabel?.textColor = UIColor.tint()

                } else {
                    
                    cell.detailTextLabel?.text = "未設定"
                    cell.detailTextLabel?.textColor = .black
                }
                
                return cell
                
            } else {

                let cell = MSDatePickerCell(style: .YMD) { (date: Date) in
                    self.birthday = date
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
                
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:

            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            } else {
                return MSDatePickerCell.preferredHeight()
            }
            
        default:
            return UITableViewAutomaticDimension
        }
    }
}
