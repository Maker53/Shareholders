Pod::Spec.new do |s|
  s.name = "ABUIComponents"
  s.version = "108.0.0-b80f07"
  s.summary = "Prebuilt ABUIComponents"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/ABUIComponents.zip' }
  s.vendored_frameworks = "ABUIComponents.xcframework"
s.dependency "IconPack"
  s.dependency "IconPack/Emoji"
  s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SharedWorkers"
  s.dependency "SnapKit"
end
