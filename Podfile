# frozen_string_literal: true

ENV['COCOAPODS_DISABLE_STATS'] = 'true' # Отключает отправку статистики по используемым подам

pre_install do
  # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
  Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

use_frameworks!
use_modular_headers!

install! 'cocoapods',
         generate_multiple_pod_projects: true,
         incremental_installation: true,
         lock_pod_sources: false,
         preserve_pod_file_structure: true,
         share_schemes_for_development_pods: true

platform :ios, '12.3'
project 'AlfaOnboarding.xcodeproj'
source 'https://cdn.cocoapods.org/'
workspace 'AlfaOnboarding'

# Зависимости
def dependency(name)
  pod name, podspec: "Dependencies/#{name}/#{name}.podspec"
end

def dependencies_fun
  dependency('AlfaFoundation')
  dependency('AMSharedProtocolsAndModels')
  dependency('AlfaNetworking')
  dependency('ThirdParty')
  dependency('PromiseKit')
  dependency('NetworkKit')
  dependency('PropertyWrappers')
  dependency('Resources')
  dependency('SharedPlatformExtensions')
  dependency('SharedPromiseKit')
  dependency('SharedProtocolsAndModels')
  dependency('SharedProviders')
  dependency('SharedRouter')
  dependency('SharedServices')
  dependency('SharedWorkers')
  dependency('ABUIComponents')
  dependency('ServerDrivenUI')
  pod 'IconPack/IconPack', podspec: "Dependencies/IconPack/IconPack.podspec"
  pod 'IconPack/Emoji', podspec: "Dependencies/IconPack/IconPack.podspec"
  pod 'IconPack/AMIconPack', podspec: "Dependencies/IconPack/IconPack.podspec"

  dependency('OHHTTPStubs')
  dependency('HTTPStubs')
  dependency('Alamofire')
  dependency('FMDB')
  dependency('ABPhoneNumberKit')
  dependency('Masonry')
  dependency('Nuke')
  dependency('Pageboy')
  dependency('PureLayout')
  dependency('RouteComposer')
  dependency('SDWebImage')
  dependency('SnapKit')
  dependency('Tabman')
  dependency('ResultScreen')
  dependency('OperationConfirmation')

end

def tests_dependencies
  dependency('TestAdditions')
  dependency('Quick')
  dependency('SnapshotTesting')
  dependency('Nimble')
end
# Methods

# Модуль в текущем репозитории
def local_module(name)
  pod name, path: "./Modules/#{name}", testspecs: ['Tests']
end

def all_tests
  pod 'AllTests', path: '.', testspecs: ['Tests']
end

def features
  local_module('Installments')
  local_module('CardReissue')
end

target 'AlfaOnboarding' do
  dependencies_fun
  features

  target 'AlfaOnboardingTests' do
    inherit! :search_paths
    tests_dependencies
  end
end

post_install do |installer|
  # Выставляем настройки таргетам проекта Pods
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      if target.is_a? Xcodeproj::Project::Object::PBXNativeTarget
        target.source_build_phase.files.delete_if do |file|
          file.file_ref.path.include? '_gen.json'
        end
      end

      target.build_configurations.each do |config|
        config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
        config.build_settings['HEADER_SEARCH_PATHS'] = ['$(inherited)', '$(SDKROOT)/usr/include/libxml2']
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.3'
        config.build_settings['OTHER_LDFLAGS'] = ['$(inherited)', '-lxml2']
      end
    end
  end
end
