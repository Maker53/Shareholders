Pod::Spec.new do |s|
  s.name = "RouteComposer"
  s.version = "2.6.6-prebuilt"
  s.summary = "Prebuilt RouteComposer"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/RouteComposer.zip' }
  s.vendored_frameworks = "RouteComposer.xcframework"

end
