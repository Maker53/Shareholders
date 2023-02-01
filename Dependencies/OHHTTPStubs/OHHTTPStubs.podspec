Pod::Spec.new do |s|
  s.name = "OHHTTPStubs"
  s.version = "9.1.0-0"
  s.summary = "Prebuilt OHHTTPStubs"
  s.platform = :ios, "10.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = { "Alfa Mobile team" => "alfabank.ci@gmail.com" }
  s.source = { :http => 'file:' + __dir__ + '/OHHTTPStubs.zip' }
  s.vendored_frameworks = "OHHTTPStubs.xcframework"
end
