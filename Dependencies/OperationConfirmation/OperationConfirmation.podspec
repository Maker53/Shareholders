Pod::Spec.new do |s|
  s.name = "OperationConfirmation"
  s.version = "8.0.3-20144d"
  s.summary = "Prebuilt OperationConfirmation"
  s.platform = :ios, "11.0"
  s.swift_version = "5.5"
  s.homepage = "https://alfabank.ru"
  s.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}
  s.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  s.source = { :http => 'file:' + __dir__ + '/OperationConfirmation.zip' }
  s.vendored_frameworks = "OperationConfirmation.xcframework"
s.dependency "ABUIComponents"
  s.dependency "Alamofire"
  s.dependency "IconPack"
  s.dependency "NetworkKit"
  s.dependency "PromiseKit"
  s.dependency "PropertyWrappers"
  s.dependency "Resources"
  s.dependency "RouteComposer"
  s.dependency "SharedPlatformExtensions"
  s.dependency "SharedPromiseKit"
  s.dependency "SharedProtocolsAndModels"
  s.dependency "SharedRouter"
  s.dependency "SharedWorkers"
  s.dependency "SnapKit"
end
