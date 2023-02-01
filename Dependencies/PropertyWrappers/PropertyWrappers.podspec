Pod::Spec.new do |s|
  s.name = "PropertyWrappers"
  s.version = "2.1.1-eeb5b1"
  s.summary = "Prebuilt PropertyWrappers"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/PropertyWrappers.zip' }
  s.vendored_frameworks = "PropertyWrappers.xcframework"
s.dependency "SharedPlatformExtensions"
end
