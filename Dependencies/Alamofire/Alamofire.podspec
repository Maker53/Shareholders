Pod::Spec.new do |s|
  s.name = "Alamofire"
  s.version = "5.4.3-7"
  s.summary = "Prebuilt Alamofire"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/Alamofire.zip' }
  s.vendored_frameworks = "Alamofire.xcframework"

end
