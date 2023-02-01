Pod::Spec.new do |s|
  s.name = "AlfaFoundation"
  s.version = "1.0-campus"
  s.summary = "Prebuilt AlfaFoundation"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2023
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/AlfaFoundation.zip' }
  s.vendored_frameworks = "AlfaFoundation.xcframework"
  s.dependency "PropertyWrappers"
  s.dependency "Resources"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "ThirdParty"
end
