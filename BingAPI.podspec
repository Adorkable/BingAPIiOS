Pod::Spec.new do |s|
  s.name         = 'BingAPI'
  s.version      = '0.1.2'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/Adorkable/BingAPIiOS'
  s.authors      =  { 'Ian Grossberg' => 'yo.ian.g@gmail.com' }
  s.summary      = 'Simple access to the BingAPI'

  s.platform     =  :ios, '8.0'
  s.source       =  { :git => 'https://github.com/Adorkable/BingAPIiOS.git', :tag => '0.1.2' }
  s.source_files = 'BingAPI/*.swift'

  s.requires_arc = true
end