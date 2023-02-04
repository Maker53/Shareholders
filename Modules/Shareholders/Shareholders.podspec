Pod::Spec.new do |s|
    s.name = 'Shareholders'
    s.summary = 'Module for displaying shareholder data'
    s.version = '1.0'
    s.author = { 'Alpha Campus' => 'alphacampus@gmail.com' }
    s.license = { :type => 'BSD' }
    s.homepage = 'https://alphabank.ru'
    s.source = { git: 'https://gitlab-alfa-campus.ru/' }
    s.source_files = "Modules/Shareholders"

    s.dependency 'ABUIComponents'
    s.dependency 'AlfaFoundation'
    s.dependency 'AlfaNetworking'
    s.dependency 'NetworkKit'
    s.dependency 'SnapKit'
 
    s.subspec 'Common' do |sp|
        sp.source_files = 'Common/**/*.swift'
    end
 
    s.subspec 'ShareholderDetails' do |sp|
        sp.source_files = 'ShareholderDetails/**/*.swift'
    end

    s.subspec 'ShareholderList' do |sp|
        sp.source_files = 'ShareholderList/**/*.swift'
    end

    s.test_spec do |t_sp|
        t_sp.name = 'Tests'
        t_sp.source_files = '**/*Tests.swift'
        t_sp.dependency 'TestAdditions'
    end
 end