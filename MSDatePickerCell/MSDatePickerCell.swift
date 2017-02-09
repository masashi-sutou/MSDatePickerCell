//
//  MSDatePickerCell.swift
//  MSDatePickerCell
//
//  Created by 須藤 将史 on 2017/02/04.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

@objc public enum DatePickerStyle: Int {
    case ymd
    case ym
    case md
}

private extension UIColor {
    static func unable() -> UIColor {
        return UIColor.init(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 205.0/255.0, alpha: 1)
    }
}

private extension Date {
    static func dateFromString(_ string: String, format: String, calendar: Calendar) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    func string(_ format: String, calendar: Calendar) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

open class MSDatePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    open var cal: Calendar = Calendar.init(identifier: .gregorian)
    open var picker: UIPickerView
    
    fileprivate var dateUpdated: (Date) -> Void
    fileprivate var style: DatePickerStyle
    
    let isJapanese: Bool = {
        if let lang: String = Locale.preferredLanguages.first {
            return lang.substring(to: lang.index(lang.startIndex, offsetBy: 2)) == "ja"
        } else {
            return false
        }
    }()
    
    let years: [Int] = (1900...2100).map { $0 }
    let months: [Int] = (1...12).map { $0 }
    let enMonths: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days: [Int] = (1...31).map { $0 }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(date: Date = Date(), style: DatePickerStyle, dateUpdated: @escaping ((Date) -> Void)) {
        
        self.dateUpdated = dateUpdated
        self.style = style
        self.picker = UIPickerView()
        self.picker.showsSelectionIndicator = true
        
        super.init(style: .default, reuseIdentifier: "DatePickerCell")
        
        self.picker.delegate = self
        self.defaultSelectPickerRow(date)
        
        self.accessoryType = .none
        self.selectionStyle = .none
        self.clipsToBounds = true
        self.contentView.addSubview(self.picker)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var insets = self.layoutMargins
        insets.left = insets.left > 20 ? insets.left : 0
        insets.right = insets.right > 20 ? insets.right : 0
        
        self.picker.frame = CGRect(x: insets.left, y: 0, width: self.frame.width - (insets.left + insets.right), height: self.picker.frame.height)
    }
    
    // MARK: - UIPickerView data source
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch self.style {
        case .ymd: return 3
        case .ym: return 2
        case .md: return 2
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch self.style {
        case .ymd:
            
            if isJapanese {
                
                if component == 0 {
                    return years.count
                } else if component == 1 {
                    return months.count
                } else {
                    return days.count
                }
                
            } else {
                
                if component == 0 {
                    return enMonths.count
                } else if component == 1 {
                    return days.count
                } else {
                    return years.count
                }
            }
            
        case .ym:
            
            if isJapanese {
                
                if component == 0 {
                    return years.count
                } else {
                    return months.count
                }
                
            } else {
                
                if component == 0 {
                    return enMonths.count
                } else {
                    return years.count
                }
            }
            
        case .md:
            
            if component == 0 {
                return months.count
            } else {
                return days.count
            }
        }
    }
    
    // MARK: - UIPickerView delegate
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch self.style {
        case .ymd:
            
            if isJapanese {
                
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
                
            } else {
                
                if component == 0 {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                } else if component == 1 {
                    
                    switch days[row] {
                    case 29, 30, 31:
                        return self.ableOrUnableDay(pickerView, year: years[pickerView.selectedRow(inComponent: 2)], month: months[pickerView.selectedRow(inComponent: 0)], day: days[row])
                    default:
                        return NSAttributedString.init(string: "\(days[row])")
                    }
                    
                } else {
                    return NSAttributedString.init(string: "\(years[row])")
                }
            }
            
        case .ym:
            
            if isJapanese {
                
                if component == 0 {
                    return NSAttributedString.init(string: "\(years[row])年")
                } else {
                    return NSAttributedString.init(string: "\(months[row])月")
                }
                
            } else {
                
                if component == 0 {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                } else {
                    return NSAttributedString.init(string: "\(years[row])")
                }
            }
            
        case .md:
            
            if component == 0 {
                
                if isJapanese {
                    return NSAttributedString.init(string: "\(months[row])月")
                } else {
                    return NSAttributedString.init(string: "\(enMonths[row])")
                }
                
            } else {
                
                switch days[row] {
                case 29, 30, 31:
                    return self.ableOrUnableDay(pickerView, year: self.cal.component(.year, from: Date()), month: months[pickerView.selectedRow(inComponent: 0)], day: days[row])
                default:
                    if isJapanese {
                        return NSAttributedString.init(string: "\(days[row])日")
                    } else {
                        return NSAttributedString.init(string: "\(days[row])")
                    }
                }
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var year: Int
        var month: Int
        var day: Int
        
        switch self.style {
        case .ymd:
            
            if isJapanese {
                year = years[pickerView.selectedRow(inComponent: 0)]
                month = months[pickerView.selectedRow(inComponent: 1)]
                day = days[pickerView.selectedRow(inComponent: 2)]
            } else {
                year = years[pickerView.selectedRow(inComponent: 2)]
                month = months[pickerView.selectedRow(inComponent: 0)]
                day = days[pickerView.selectedRow(inComponent: 1)]
            }
            
            let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            // 存在しない日付を変換した場合
            if dateString != date.string("yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                self.defaultSelectPickerRow(date)
            }
            
            self.dateUpdated(date)
            
        case .ym:
            
            if isJapanese {
                year = years[pickerView.selectedRow(inComponent: 0)]
                month = months[pickerView.selectedRow(inComponent: 1)]
            } else {
                year = years[pickerView.selectedRow(inComponent: 1)]
                month = months[pickerView.selectedRow(inComponent: 0)]
            }
            
            let dateString: String = String(format: "%d/%02d/01 00:00:00 +0900", year, month)
            
            self.dateUpdated(Date.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
            
        case .md:
            
            year = self.cal.component(.year, from: Date())
            month = months[pickerView.selectedRow(inComponent: 0)]
            day = days[pickerView.selectedRow(inComponent: 1)]
            let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
            let date: Date = Date.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
            
            if dateString != date.string("yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
                // 存在しない日付を変換した場合
                self.defaultSelectPickerRow(date)
            }
            
            self.dateUpdated(Date.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal))
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if isJapanese {
            switch self.style {
            case .ymd:
                return pickerView.frame.width * 0.3
            case .ym:
                return pickerView.frame.width * 0.5
            case .md:
                return pickerView.frame.width * 0.5
            }
        } else {
            switch self.style {
            case .ymd:
                if component == 0 {
                    return pickerView.frame.width * 0.4
                } else if component == 1 {
                    return pickerView.frame.width * 0.2
                } else {
                    return pickerView.frame.width * 0.4
                }
            case .ym:
                return pickerView.frame.width * 0.5
            case .md:
                return pickerView.frame.width * 0.5
            }
        }
    }
    
    open class func preferredHeight() -> CGFloat {
        return 216
    }
    
    // MARK: Pickerのデフォルト値を設定
    
    final fileprivate func defaultSelectPickerRow(_ date: Date) {
        
        switch self.style {
        case .ymd:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }
            
            if isJapanese {
                self.picker.selectRow(yi, inComponent:0, animated:true)
                self.picker.selectRow(mi, inComponent:1, animated:true)
                self.picker.selectRow(di, inComponent:2, animated:true)
            } else {
                self.picker.selectRow(yi, inComponent:2, animated:true)
                self.picker.selectRow(mi, inComponent:0, animated:true)
                self.picker.selectRow(di, inComponent:1, animated:true)
            }
            
        case .ym:
            
            var yi: Int = 0
            if let yearIndex = years.index(of: self.cal.component(.year, from: date)) {
                yi = yearIndex
            }
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            
            if isJapanese {
                self.picker.selectRow(yi, inComponent:0, animated:true)
                self.picker.selectRow(mi, inComponent:1, animated:true)
            } else {
                self.picker.selectRow(yi, inComponent:1, animated:true)
                self.picker.selectRow(mi, inComponent:0, animated:true)
            }
            
        case .md:
            
            var mi: Int = 0
            if let monthIndex = months.index(of: self.cal.component(.month, from: date)) {
                mi = monthIndex
            }
            self.picker.selectRow(mi, inComponent:0, animated:true)
            
            var di: Int = 0
            if let dayIndex = days.index(of: self.cal.component(.day, from: date)) {
                di = dayIndex
            }
            self.picker.selectRow(di, inComponent:1, animated:true)
        }
    }
    
    // MARK: 存在する・しない日付で色を変更
    
    fileprivate func ableOrUnableDay(_ pickerView: UIPickerView, year: Int, month: Int, day: Int) -> NSAttributedString {
        
        let dateString: String = String(format: "%d/%02d/%02d 00:00:00 +0900", year, month, day)
        let date: Date = Date.dateFromString(dateString, format: "yyyy/MM/dd HH:mm:ss Z", calendar: self.cal)
        
        if dateString != date.string("yyyy/MM/dd HH:mm:ss Z", calendar: self.cal) {
            
            // 存在しない日付を変換した場合
            if isJapanese {
                return NSAttributedString.init(string: "\(day)日", attributes: [NSForegroundColorAttributeName: UIColor.unable()])
            } else {
                return NSAttributedString.init(string: "\(day)", attributes: [NSForegroundColorAttributeName: UIColor.unable()])
            }
            
        } else {
            if isJapanese {
                return NSAttributedString.init(string: "\(day)日")
            } else {
                return NSAttributedString.init(string: "\(day)")
            }
        }
    }
}
