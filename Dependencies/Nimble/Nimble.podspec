Pod::Spec.new do |s|
  s.name = "Nimble"
  s.version = "10.0.0"
  s.summary = "Prebuilt Nimble"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/Nimble.zip' }
  s.vendored_frameworks = "Nimble.xcframework"
s.requires_arc = true
s.weak_framework = "XCTest"
s.pod_target_xcconfig = {
  "APPLICATION_EXTENSION_API_ONLY" => "YES",
  "DEFINES_MODULE" => "YES",
  "ENABLE_BITCODE" => "NO",
  "ENABLE_TESTING_SEARCH_PATHS" => "YES",
  "OTHER_LDFLAGS" => "$(inherited) -weak-lXCTestSwiftSupport -Xlinker -no_application_extension",
}

end
