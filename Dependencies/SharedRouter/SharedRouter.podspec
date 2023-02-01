Pod::Spec.new do |s|
  s.name = "SharedRouter"
  s.version = "9.0.3-94d86c"
  s.summary = "Prebuilt SharedRouter"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/SharedRouter.zip' }
  s.vendored_frameworks = "SharedRouter.xcframework"
s.dependency "ABUIComponents"
  s.dependency "IconPack"
  s.dependency "PromiseKit"
  s.dependency "PropertyWrappers"
  s.dependency "Resources"
  s.dependency "RouteComposer"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SharedWorkers"
  s.dependency "SnapKit"
end
