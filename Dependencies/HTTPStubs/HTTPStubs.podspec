Pod::Spec.new do |s|
  s.name = "HTTPStubs"
  s.version = "2.0.5-b0244a"
  s.summary = "Prebuilt HTTPStubs"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/HTTPStubs.zip' }
  s.vendored_frameworks = "HTTPStubs.xcframework"
s.dependency "IconPack"
  s.dependency "IconPack/AMIconPack"
  s.dependency "IconPack/Emoji"
end
