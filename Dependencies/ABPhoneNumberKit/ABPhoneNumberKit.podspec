Pod::Spec.new do |s|
  s.name = "ABPhoneNumberKit"
  s.version = "3.2.0-4-prebuilt"
  s.summary = "Prebuilt ABPhoneNumberKit"
  s.platform = :ios, "12.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file://' + __dir__ + '/ABPhoneNumberKit.zip' }
  s.vendored_frameworks = "ABPhoneNumberKit.xcframework"
  
end
