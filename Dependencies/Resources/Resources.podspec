Pod::Spec.new do |s|
  s.name = "Resources"
  s.version = "5.1.5-952168"
  s.summary = "Prebuilt Resources"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/Resources.zip' }
  s.vendored_frameworks = "Resources.xcframework"
s.dependency "PropertyWrappers"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedProtocolsAndModels"
end
