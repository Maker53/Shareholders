Pod::Spec.new do |s|
  s.name = "Masonry"
  s.version = "1.1.0-prebuilt"
  s.summary = "Prebuilt Masonry"
  s.platform = :ios, "12.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = { "Alfa Mobile team" => "alfabank.ci@gmail.com" }
  s.source = { :http => 'file:' + __dir__ + '/Masonry.zip' }
  s.vendored_frameworks = "Masonry.xcframework"
end
