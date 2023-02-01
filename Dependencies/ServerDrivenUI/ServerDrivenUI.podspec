Pod::Spec.new do |s|
  s.name = "ServerDrivenUI"
  s.version = "28.0.0-055c0b"
  s.summary = "Prebuilt ServerDrivenUI"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/ServerDrivenUI.zip' }
  s.vendored_frameworks = "ServerDrivenUI.xcframework"
s.dependency "ABUIComponents"
  s.dependency "IconPack"
  s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SharedWorkers"
  s.dependency "SnapKit"
end
