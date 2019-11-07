Pod::Spec.new do |s|
    s.name             = 'SwiftDI'
    s.version          = '1.1'
    s.summary          = 'Perfect dependency injection using property wrappers!'
  
    s.homepage         = 'https://litecode.dev/'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Vladislav Prusakov' => 'spectraldragonchannel@gmail.com' }
    s.source           = { :git => 'https://github.com/LiteCode/SwiftDI.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.1'
    s.source_files = 'Sources/SwiftDI/**/*.{swift}'

  end
  