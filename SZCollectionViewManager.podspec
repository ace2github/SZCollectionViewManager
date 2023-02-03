Pod::Spec.new do |s|
  s.name        = 'SZCollectionViewManager'
  s.version     = '0.1.0'
  s.authors     = { 'Hui' => '173141667@qq.com' }
  s.homepage    = 'https://github.com/ace2github/SZCollectionViewManager'
  s.summary     = 'Powerful data driven content manager for UICollectionView.'
  s.source      = { :git => 'https://github.com/ace2github/SZCollectionViewManager.git',
                    :tag => s.version.to_s }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '.0'
  s.requires_arc = true
  s.source_files = 'SZCollectionViewManager/Core', 'SZCollectionViewManager/CellItems'
  # Swift support uses dynamic frameworks and is therefore only supported on iOS > 8.
  s.ios.deployment_target = '8.0'
  s.swift_version = "4.2"
end
