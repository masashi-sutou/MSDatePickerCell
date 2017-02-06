Pod::Spec.new do |s|
  s.name                  = "MSDatePickerCell"
  s.version               = "1.0.5"
  s.summary               = "MSDatePickerCell is customized UITableViewCell for datePickerView."
  s.homepage              = "https://github.com/masashi-sutou/MSDatePickerCell"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/masashi-sutou/MSDatePickerCell.git",  :tag => s.version }
  s.source_files          = "MSDatePickerCell", "MSDatePickerCell/**/*.{swift}"
  s.requires_arc          = true
  s.platform              = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { "masashi-sutou" => "sutou.masasi@gmail.com" }
end
