Pod::Spec.new do |s|
  s.name = "SnapKit"
  s.version = "5.0.1-prebuilt"
  s.summary = "Prebuilt SnapKit"
  s.platform = :ios, "12.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = { "Alfa Mobile team" => "alfabank.ci@gmail.com" }
  s.source = { :http => 'file:' + __dir__ + '/SnapKit.zip' }
  s.vendored_frameworks = "SnapKit.xcframework"
end
