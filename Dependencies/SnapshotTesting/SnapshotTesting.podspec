Pod::Spec.new do |s|
  s.name = "SnapshotTesting"
  s.version = "1.10.0-1"
  s.summary = "Prebuilt SnapshotTesting"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SnapshotTesting.zip' }
  s.vendored_frameworks = "SnapshotTesting.xcframework"

end
