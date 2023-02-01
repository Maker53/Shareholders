Pod::Spec.new do |s|
  s.name = "SharedServices"
  s.version = "21.0.2-5b6cf8"
  s.summary = "Prebuilt SharedServices"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedServices.zip' }
  s.vendored_frameworks = "SharedServices.xcframework"
s.dependency "ABUIComponents"
  s.dependency "Alamofire"
  s.dependency "IconPack"
  s.dependency "NetworkKit"
  s.dependency "PromiseKit"
  s.dependency "PropertyWrappers"
  s.dependency "Resources"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SharedWorkers"
  s.dependency "SnapKit"
end
