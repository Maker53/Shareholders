Pod::Spec.new do |s|
  s.name = "TestAdditions"
  s.version = "10.1.2-f88d53"
  s.summary = "Prebuilt TestAdditions"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/TestAdditions.zip' }
  s.vendored_frameworks = "TestAdditions.xcframework"
  s.dependency "HTTPStubs"
  s.dependency "Nimble"
  s.dependency "OHHTTPStubs"
  s.dependency "Quick"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SnapKit"
  s.dependency "SnapshotTesting"
end
