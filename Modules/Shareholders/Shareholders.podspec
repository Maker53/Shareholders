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
    s.dependency 'SharedRouter'
 
    s.subspec 'Common' do |sp|
        sp.source_files = 'Common/**/*.swift'
        sp.exclude_files = ['Common/**/*Tests.swift', 'Common/**/*+Seeds.swift']
    end
 
    s.subspec 'ShareholderDetails' do |sp|
        sp.source_files = 'ShareholderDetails/**/*.swift'
        sp.exclude_files = 'ShareholderDetails/**/*Tests.swift'
    end

    s.subspec 'ShareholderList' do |sp|
        sp.source_files = 'ShareholderList/**/*.swift'
        sp.exclude_files = 'ShareholderList/**/*Tests.swift'
    end

    s.subspec 'Mock' do |sp|
        sp.source_files = '**/*Mock.swift'
        sp.source_files = '**/*Mocks.swift'
    end
    
    s.subspec 'Seeds' do |sp|
        sp.source_files = '**/*+Seeds.swift'
    end

    s.test_spec do |t_sp|
        t_sp.name = 'Tests'
	t_sp.test_type = 'unit'
        t_sp.source_files = '**/*Tests.swift'
        t_sp.dependency 'TestAdditions'
    end
 end