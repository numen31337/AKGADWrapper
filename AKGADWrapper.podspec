Pod::Spec.new do |s|
  s.name           = "AKGADWrapper"
  s.version        = "1.0.3"
  s.summary        = "UIViewController wrapper with the AdMob"
  s.description    = "A wrapper for a UIViewController with a GADBannerView at the bottom and autolayout support"
  s.homepage       = "https://github.com/numen31337/AKGADWrapper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author         = { "Oleksandr Kirichenko" => "contact@oleksandrkirichenko.com" }
  s.platform              = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/numen31337/AKGADWrapper.git", :tag => "#{s.version}" }
  s.source_files  = "AKGADWrapper/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true

  s.dependency 'Google-Mobile-Ads-SDK'
  s.dependency 'SAMKeychain'

  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/Google-Mobile-Ads-SDK/**',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

end
