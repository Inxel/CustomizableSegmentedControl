Pod::Spec.new do |s|
  s.name             = 'CustomizableSegmentedControl'
  s.version          = '0.1.0'
  s.summary          = 'If you're bored with standard segmented control, this framework is for you! CustomizableSegmentedControl is a customizable segmented control written in SwiftUI 2.0.'
  s.homepage         = 'https://github.com/Inxel/CustomizableSegmentedControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tyoma Zagosikn' => 'artyzago@gmail.com' }
  s.source           = { :git => 'https://github.com/Inxel/CustomizableSegmentedControl.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*'
end
