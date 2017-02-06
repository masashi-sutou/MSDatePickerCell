MSDatePickerCell
====

## Overview
### DatePickerStyle

.ymd | .ym | .md
--- | --- | ---
<img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/ymd.jpg" width="320"/> | <img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/ym.jpg" width="320"/> | <img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/md.jpg" width="320"/>

## Requirement
- Xcode 8
- Swift 3
- iOS 8.0 or later

## Usage
```Swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = MSDatePickerCell(style: .ymd) { (date: Date) in
    // Do Something
  }
  return cell
}
```

## Installation
#### [CocoaPods](https://cocoapods.org/)
Add the following line to your Podfile:
```ruby
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod "MSDatePickerCell"
end
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```ruby
github "masashi-sutou/MSDatePickerCell"
```

## Licence
MSDatePickerCell is available under the MIT license. See the LICENSE file for more info.
