#
#  Be sure to run `pod spec lint SimpleCheckbox.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DateTextField"
  s.version      = "2.2.0"
  s.summary      = "A date input textfield"
  s.swift_version = '5.1'

  s.description  = <<-DESC
  A Swift UITextField subclass designed to make entering dates easier, faster and more flexible than the standard UIDatePicker.
                   DESC

  s.homepage     = "https://github.com/BeauNouvelle/DateTextField"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Beau Nouvelle"
  s.social_media_url   = "http://twitter.com/BeauNouvelle"

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/BeauNouvelle/DateTextField.git", :tag => "#{s.version}" }

  s.source_files  = "DateTextField/*.{swift}"

end