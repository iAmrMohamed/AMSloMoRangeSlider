Pod::Spec.new do |s|

  s.name         = "AMSloMoRangeSlider"
  s.version      = "1.0.0"
  s.summary      = "iOS Slow Motion Video Range Slider in Swift"

  s.homepage     = "https://github.com/iAmrMohamed/AMSloMoRangeSlider"

  s.license      = "MIT"

  s.author             = { "Amr Mohamed" => "iAmrMohamed@gmail.com" }
  s.social_media_url   = "https://twitter.com/iAmrMohamed"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/iAmrMohamed/AMSloMoRangeSlider.git", :tag => s.version }

  s.source_files  = "AMSloMoRangeSlider/*.swift"

  s.frameworks = "UIKit"

  s.requires_arc = true

end
