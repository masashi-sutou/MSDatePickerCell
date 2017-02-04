//
//  MSDatePickerCell.swift
//  MSDatePickerCell
//
//  Created by 須藤 将史 on 2017/02/04.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

@objc enum DatePickerStyle: Int {
    case YMD
    case YM
    case MD
}

private extension UIColor {
    static func unable() -> UIColor {
        return UIColor.init(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 205.0/255.0, alpha: 1)
    }
}

private extension Date {
    static func dateFromString(string: String, format: String, calendar: Calendar) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    func string(format: String, calendar: Calendar) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

class MSDatePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var cal: Calendar = Calendar.init(identifier: .gregorian)
    
    private var datePicker: UIPickerView
    private var dateUpdated: (Date) -> Void
    private var style: DatePickerStyle
    
    let years: [Int] = (1980...2030).map { $0 }
    let months: [Int] = (1...12).map { $0 }
    let days: [Int] = (1...31).map { $0 }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(date: Date = Date(), style: DatePickerStyle, dateUpdated: @escaping ((Date) -> Void)) {
        
        self.dateUpdated = dateUpdated
        self.style = style
        self.datePicker = UIPickerView()
        self.datePicker.showsSelectionIndicator = true
        
        super.init(style: .default, reuseIdentifier: "DatePickerCell")
        
        self.datePicker.delegate = self
        self.defaultSelectPickerRow(date: date)
        
        self.accessoryType = .none
        self.selectionStyle = .none
        self.clipsToBounds = true
        self.contentView.addSubview(self.datePicker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var insets = self.layoutMargins
        insets.left = insets.left > 20 ? insets.left : 0
        insets.right = insets.right > 20 ? insets.right : 0
        
        self.datePicker.frame = CGRect(x: insets.left, y: 0, width: self.frame.width - (insets.left + insets.right), height: self.datePicker.frame.height)
    }
    
    // MARK: - UIPickerView data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch self.style {
        case .YMD: return 3
        case .YM: return 2
        case .MD: return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch self.style {
        case .YMD:
            
            if component == 0 {
                return years.count
            } else if component == 1 {
                return months.count
            } else {
                return days.count
            }
            
        case .YM:
            
            if component == 0 {
                return years.count
            } else {
                return months.count
            }
            
        case .MD:
            
            if component == 0 {
                return months.count
            } else {
                return days.count
            }
        }
    }
    
    // MARK: - UIPickerView delegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch self.style {
        case .YMD:
            
            if component == 0 {
                return NSAttributedString.init(string: "\(years[row])年")
            } else if component == 1 {
                return NSAttributedString.init(string: "\(months[row])月")
            } else {
                
                switch days[row] {
                case 29, 30, 31:
                    return self.ableOrUnableDay(pickerView, year: years[pickerView.selectedRow(inComponent: 0)], month: months[pickerView.selectedRow(inComponent: 1)], day: days[row])
                default:
                    return NSAttributedString.init(string: "\(days[row])日")
                }
            }
            
        case .YM:
            
            if component == 0 {
                return NSAttributedString.init(string: "\(years[row])年")
            } else {
                return NSAttributedString.init(string: "\(months[row])月")
            }
            
        case .MD:
            
            if component == 0 {
                return NSAttributedString.init(string: "\(months[row])月")
            } else {
                
                switch days[row] {
                case 29, 30, 31:
                    return self.ableOrUnableDay(pickerView, year: self.cal.component(.year, from: Date()), month: months[pickerView.selectedRow(inComponent: 0)], day: days[row])
                default:
                    return NSAttributedString.init(string: "\(days[row])日")
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch self.style {
        case .YMD:
            
            let year: Int = years[pickerView.selectedRow(inComponent: 0)]
            let month: Int = months[pickerView.selectedRow(inComponent: 1)]
            let day: Int = days[pickerView.selectedRow(inComponent: 2)]
            let dateString: String = String(format: "%d/%d/%d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            // 存在しない日付を変換した場合
            if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                self.defaultSelectPickerRow(date: date)
            }
            
            self.dateUpdated(date)
            
        case .YM:
            
            let year: Int = years[pickerView.selectedRow(inComponent: 0)]
            let month: Int = months[pickerView.selectedRow(inComponent: 1)]
            let dateString: String = String(format: "%d/%d/1 00:00:00 +0900", year, month)
            
            self.dateUpdated(Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
            
        case .MD:
            
            let year: Int = self.cal.component(.year, from: Date())
            let month: Int = months[pickerView.selectedRow(inComponent: 0)]
            let day: Int = days[pickerView.selectedRow(inComponent: 1)]
            let dateString: String = String(format: "%d/%d/%d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                // 存在しない日付を変換した場合
                self.defaultSelectPickerRow(date: date)
            }
            
            self.dateUpdated(Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
        }
    }
    
    open class func preferredHeight() -> CGFloat {
        return 216
    }
    
    // MARK: Pickerのデフォルト値を設定
    
    final private func defaultSelectPickerRow(date: Date) {
        
        switch self.style {
        case .YMD:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            self.datePicker.selectRow(yi, inComponent:0, animated:true)
            
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            self.datePicker.selectRow(mi, inComponent:1, animated:true)
            
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }
            self.datePicker.selectRow(di, inComponent:2, animated:true)
            
        case .YM:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            self.datePicker.selectRow(yi, inComponent:0, animated:true)
            
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            self.datePicker.selectRow(mi, inComponent:1, animated:true)
            
        case .MD:
            
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            self.datePicker.selectRow(mi, inComponent:0, animated:true)
            
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }
            self.datePicker.selectRow(di, inComponent:1, animated:true)
        }
    }
    
    // MARK: 存在する・しない日付で色を変更
    
    private func ableOrUnableDay(_ pickerView: UIPickerView, year: Int, month: Int, day: Int) -> NSAttributedString {
        
        let dateString: String = String(format: "%d/%d/%d 00:00:00 +0900", year, month, day)
        let date: Date = Date.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
        
        if dateString != date.string(format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
            // 存在しない日付を変換した場合
            return NSAttributedString.init(string: "\(day)日", attributes: [NSForegroundColorAttributeName: UIColor.unable()])
        } else {
            return NSAttributedString.init(string: "\(day)日")
        }
    }
}
