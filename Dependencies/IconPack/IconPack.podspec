# frozen_string_literal: true

Pod::Spec.new do |spec|
  spec.name = "IconPack"
  spec.summary = "Prebuilded IconPack"
  spec.version = "966"
  spec.author = {"Alfa Mobile team"=>"alfabank.ci@gmail.com"}
  spec.homepage = "http://git/projects/IOSUTILS/repos/IconPack/browse"
  spec.platform = :ios, "9.0"
  spec.source = { :http => 'file:' + __dir__ + '/IconPack.zip' }
  spec.swift_version = "5.5"
  spec.license = {:type=>"Custom", :text=>"Copyright 2018 - 2022
Permission is granted to Alfa-Bank
"}

  spec.default_subspec = "IconPack"

  spec.subspec "IconPack" do |subspec|
    subspec.vendored_frameworks = "IconPack.xcframework"
  end

  spec.subspec "AMIconPack" do |subspec|
    subspec.vendored_frameworks = "AMIconPack.xcframework"
  end

  spec.subspec "Emoji" do |subspec|
    subspec.vendored_frameworks = "Emoji.xcframework"
  end
end
