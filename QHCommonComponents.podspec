Pod::Spec.new do |s|
  s.name             = 'QHCommonComponents'
  s.version          = '0.0.2'
  s.summary          = 'QHCommonComponents of QHWL project.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/A1129434577'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'A1129434577' => '1129434577@qq.com' }
  #s.source           = { :git => "https://github.com/A1129434577/QHCommonComponents.git", :tag => s.version.to_s }
  s.source           = { :git => "/Users/liubin/Desktop/个人仓库/MyProject/巧合物联/QHCommonComponentsExample", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'


  s.subspec 'QHMacros' do |ss|
    ss.dependency 'CommonComponents/Macros', '~> 0.0.1'

    ss.source_files = 'QHCommonComponents/QHMacros/**/*'
    ss.prefix_header_contents = <<-EOS
       #ifdef __OBJC__
       #import "QHSystemMacro.h"
       #import "QHUIMacro.h"
       #import "QHFunctionMacro.h"
       #endif 
    EOS
  end

  
  s.subspec 'QHNSObjects' do |ss|

    ss.subspec 'TEST' do |sss|
      #sss.dependency 'CommonComponents/NSObjects/LBEncrypt', '~> 0.0.1'
      sss.source_files = 'QHCommonComponents/QHNSObjects/TEST/*.{h,m}'
    end
  end

  

  


end
