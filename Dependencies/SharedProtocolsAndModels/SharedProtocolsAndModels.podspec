Pod::Spec.new do |s|
  s.name = "SharedProtocolsAndModels"
  s.version = "53.1.2-7b2c35"
  s.summary = "Prebuilt SharedProtocolsAndModels"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedProtocolsAndModels.zip' }
  s.vendored_frameworks = "SharedProtocolsAndModels.xcframework"
s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
end
