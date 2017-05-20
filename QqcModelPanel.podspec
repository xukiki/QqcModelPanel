Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "QqcModelPanel"
  s.version      = "1.0.1"
  s.summary      = "QqcModelPanel"
  s.homepage     = "https://github.com/xukiki/QqcModelPanel"
  s.source       = { :git => "https://github.com/xukiki/QqcModelPanel.git", :tag => "#{s.version}" }
  
  s.source_files  = ["QqcModelPanel/*.{h,m}"]

  s.dependency "QqcSizeDef"
  s.dependency "UIView-Qqc"
  
end
