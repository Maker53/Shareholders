Pod::Spec.new do |s|
  s.name = "SharedWorkers"
  s.version = "5.1.1-d45498"
  s.summary = "Prebuilt SharedWorkers"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedWorkers.zip' }
  s.vendored_frameworks = "SharedWorkers.xcframework"
s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
end
