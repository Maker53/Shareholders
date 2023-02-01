Pod::Spec.new do |s|
  s.name = "SharedPlatformExtensions"
  s.version = "6.3.1-ad78f1"
  s.summary = "Prebuilt SharedPlatformExtensions"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedPlatformExtensions.zip' }
  s.vendored_frameworks = "SharedPlatformExtensions.xcframework"

end
