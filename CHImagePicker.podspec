
Pod::Spec.new do |s|

  s.name         = "CHImagePicker"
  s.version      = "1.0.0" 
  s.summary      = "快捷选择照片的组件，自定义样式"
  s.description  = "一个方法支持选中手机相册里的照片并且返回UIImage" 
  s.homepage     = "https://github.com/chausson/CHPickImageDemo.git"
  s.license      = "MIT"
  s.author       = { "Chausson" => "232564026@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/chausson/CHPickImageDemo.git", :tag => "1.0.0"}
  s.source_files  = "CHImagePicker/*.{h,m}","CHImagePicker/ChaussonSheet/*.{h,m}"

 
end

