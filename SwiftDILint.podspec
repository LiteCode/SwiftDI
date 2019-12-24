Pod::Spec.new do |s|
    s.name                = 'SwiftDILint'
    s.version             = '1.1'
    s.summary             = 'Perfect dependency injection using property wrappers!'
    s.homepage            = 'https://litecode.dev/'
    s.license             = { :type => 'MIT', :file => 'LICENSE' }
    s.author              = { 'Vladislav Prusakov' => 'spectraldragonchannel@gmail.com' }
    s.source              = { http: "#{s.homepage}/releases/download/#{s.version}/portable_swiftdilint.zip" }
    s.preserve_paths      = '*'
    s.exclude_files  = '**/file.zip'
  end
  
