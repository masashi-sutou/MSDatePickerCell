//
//  Date+Custom.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/06.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import Foundation

public extension Date {
    func string(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
