#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_libpd.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_libpd'
  s.version          = '0.0.1'
  s.summary          = 'A libpd plugin for Flutter.'
  s.description      = <<-DESC
A libpd plugin for Flutter.
                       DESC
  s.homepage         = 'https://ovaom.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OVAOM' => 'contact@ovaom.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'libpd_ios', '0.12.3'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
