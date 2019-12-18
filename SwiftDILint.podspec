Pod::Spec.new do |s|
    s.name                = 'SwiftDILint'
    s.version             = '1.1'
    s.summary             = 'Perfect dependency injection using property wrappers!'
  
    s.homepage            = 'https://litecode.dev/'
    s.license             = { :type => 'MIT', :file => 'LICENSE' }
    s.author              = { 'Vladislav Prusakov' => 'spectraldragonchannel@gmail.com' }
    s.source              = { :git => 'https://github.com/LiteCode/SwiftDI.git', :tag => s.version.to_s }
  
    s.platform            = :osx, '10.10'
    s.swift_version       = '5.1'
    s.source_files        = 'Sources/SwiftDILint/**/*.{swift}'
    s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
    s.dependency          'SourceKittenFramework', '~> 0.27.0'

  end
  
