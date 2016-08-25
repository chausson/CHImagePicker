Pod::Spec.new do |s|

  s.name         = "CHImagePicker"
  s.version      = "1.1.3"
  s.summary      = "快捷选择照片的组件，自定义样式"
  s.description  = "增加了一个新的调用方法，设置代理的入口"
  s.homepage     = "https://github.com/chausson/CHImagePicker.git"
  s.license      = "MIT"
  s.author       = { "Chausson" => "232564026@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/chausson/CHImagePicker.git", :tag => "1.1.3"}
  s.source_files  = "CHImagePicker/*.{h,m}","CHImagePicker/ChaussonSheet/*.{h,m}"
end

