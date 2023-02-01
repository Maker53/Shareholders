Pod::Spec.new do |s|
  s.name = "SharedPromiseKit"
  s.version = "3.1.2-c3999e"
  s.summary = "Prebuilt SharedPromiseKit"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedPromiseKit.zip' }
  s.vendored_frameworks = "SharedPromiseKit.xcframework"
s.dependency "PromiseKit"
  s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
end
