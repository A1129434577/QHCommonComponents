Pod::Spec.new do |s|
  s.name             = 'QHCommonComponents'
  s.version          = '0.0.5'
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
    ss.dependency 'CommonComponents/Macros'

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
    ss.subspec 'QHEncryptHelper' do |sss|
      sss.dependency 'CommonComponents/NSObjects/LBEncrypt'
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHEncryptHelper/**/*'
    end
    
    ss.subspec 'QHBluetooth' do |sss|
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHBluetooth/**/*'
    end
  end

  s.subspec 'QHUIViewControllers' do |ss|
    ss.subspec 'QHPayWaysSelectVC' do |sss|
      sss.dependency 'CommonComponents/NSObjects/LBCustemPresentTransitions'
      sss.dependency 'SDWebImage'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHPayWaysSelectVC/**/*'
    end
    
    ss.subspec 'QHAlertController' do |sss|
      sss.dependency 'CommonComponents/UIViewControllers/LBAlertController'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHAlertController/**/*'
    end

    ss.subspec 'UIViewController+SVProgressHUD' do |sss|
      sss.dependency 'SVProgressHUD'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/UIViewController+SVProgressHUD/**/*'
    end

    ss.subspec 'QHQRViewController' do |sss|
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHQRViewController/**/*'
    end
  end


  #pod spec lint  --use-libraries


end
