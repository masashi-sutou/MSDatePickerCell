MSDatePickerCell
====

## Overview
### DatePickerStyle

.YMD | .YM | .MD
--- | --- | ---
<img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/ymd.jpg" width="320"/> | <img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/ym.jpg" width="320"/> | <img src="https://raw.githubusercontent.com/masashi-sutou/MSDatePickerCell/master/demo_images/md.jpg" width="320"/>

## Requirement
- Xcode 8
- Swift 3
- iOS 8.0 or later

## Usage
```Swift
let cell = MSDatePickerCell(style: .YMD) { (date: Date) in
  // Do Something
}
return cell
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

## Licence
MSDatePickerCell is available under the MIT license. See the LICENSE file for more info.
