Pod::Spec.new do |s|

  s.name         = "CHImagePicker"
  s.version      = "1.4.1"
  s.summary      = "快捷选择照片的组件，自定义样式"
  s.description  = "增加新的拍照以及列表接口，并且增加列表弹出的状态"
  s.homepage     = "https://github.com/chausson/CHImagePicker.git"
  s.license      = "MIT"
  s.author       = { "Chausson" => "232564026@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/chausson/CHImagePicker.git", :tag => s.version}
  s.source_files  = "CHImagePicker/*.{h,m}","CHImagePicker/ChaussonSheet/*.{h,m}","CHImagePicker/CustomCamera/*.{h,m}"
  s.resource = "CHImagePicker/CustomCamera/LMSTakePhotoController.xib"
end	

