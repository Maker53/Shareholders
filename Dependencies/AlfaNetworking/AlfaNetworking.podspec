Pod::Spec.new do |s|
  s.name = "AlfaNetworking"
  s.version = "1.5.1-campus"
  s.summary = "Prebuilt AlfaNetworking"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2023
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/AlfaNetworking.zip' }
  s.vendored_frameworks = "AlfaNetworking.xcframework"
  s.dependency "AlfaFoundation"
  s.dependency "AMSharedProtocolsAndModels"
  s.dependency "FMDB"
  s.dependency "HTTPStubs"
  s.dependency "NetworkKit"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedServices"
end
