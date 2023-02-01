Pod::Spec.new do |s|
  s.name = "NetworkKit"
  s.version = "12.1.2-794ae4"
  s.summary = "Prebuilt NetworkKit"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/NetworkKit.zip' }
  s.vendored_frameworks = "NetworkKit.xcframework"
s.dependency "Alamofire"
  s.dependency "PromiseKit"
  s.dependency "PropertyWrappers"
  s.dependency "Resources"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedProtocolsAndModels"
end
