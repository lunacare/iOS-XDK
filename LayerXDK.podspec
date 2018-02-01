Pod::Spec.new do |s|
  # Package information
  s.name                      = 'LayerXDK'
  s.version                   = '1.0.0-pre1'
  s.summary                   = 'Layer XDK for Cocoa is a collection of Frameworks that provide native interfaces to access the Layer communications cloud and UI components to build rich messaging apps.'
  s.homepage                  = 'https://github.com/layerhq/iOS-XDK'
  s.social_media_url          = 'http://twitter.com/layer'
  s.documentation_url         = 'https://docs.layer.com'
  s.license                   = 'Apache2'
  s.author                    = { 'Blake Watters'   => 'blake@layer.com',
                                  'Daniel Maness'   => 'daniel@layer.com',
                                  'Jeremy Wyld'     => 'jeremy@layer.com',
                                  'Klemen Verdnik'  => 'klemen@layer.com',
                                  'Łukasz Przytuła' => 'lukasz@layer.com' }
  s.source                    = { git: "https://github.com/layerhq/iOS-XDK.git", tag: "v#{s.version}" }
  s.requires_arc              = true
  s.ios.deployment_target     = '9.0'

  s.subspec 'UI' do |sub|
    # UI is a set of communications user interface components integrated with Layer Messaging for iOS.
    sub.platform               = :ios, '9.0'
    sub.frameworks             = 'UIKit', 'CoreLocation', 'MapKit', 'MobileCoreServices', 'SafariServices', 'QuickLook'
    sub.source_files           = 'UI/Code/**/*.{h,m}'
    sub.ios.resource_bundle    = { 'LayerXDKUIResource' => 'UI/Resources/*' }
    sub.dependency               'LayerKit', '= 1.0.0-pre1'
  end

  s.default_subspec         = 'UI'
end
