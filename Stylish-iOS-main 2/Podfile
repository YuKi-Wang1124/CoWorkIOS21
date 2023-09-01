# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'

target 'STYLiSH' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for STYLiSH
  pod 'Kingfisher', '~> 7.6.0'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'JGProgressHUD', :git => 'https://github.com/ronanociosoig/JGProgressHUD'
  pod 'KeychainAccess'
  pod 'FBSDKLoginKit'
  pod 'SwiftLint'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
  end
  
end
