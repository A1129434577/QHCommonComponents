Pod::Spec.new do |s|
  s.name             = 'QHCommonComponents'
  s.version          = '0.0.9'
  s.summary          = 'QHCommonComponents of QHWL project.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/A1129434577'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'A1129434577' => '1129434577@qq.com' }
  s.source           = { :git => "https://github.com/A1129434577/QHCommonComponents.git", :tag => s.version.to_s }
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
    ss.dependency 'QHCommonComponents/QHMacros'

    ss.subspec 'QHEncryptHelper' do |sss|
      sss.dependency 'CommonComponents/NSObjects/LBEncrypt'
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHEncryptHelper/**/*'
    end
    
    ss.subspec 'QHBluetooth' do |sss|
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHBluetooth/**/*'
    end

    ss.subspec 'QHPayKit' do |sss|
      sss.dependency 'XHPayKit'
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHPayKit/**/*'
    end

    ss.subspec 'NSObject+SVProgressHUD' do |sss|
      sss.dependency 'SVProgressHUD'
      sss.source_files = 'QHCommonComponents/QHNSObjects/NSObject+SVProgressHUD/**/*'
    end
  end


  s.subspec 'QHUIViewControllers' do |ss|
    ss.dependency 'QHCommonComponents/QHMacros'

    ss.subspec 'QHPayWaysSelectVC' do |sss|
      sss.dependency 'SDWebImage'
      sss.dependency 'CommonComponents/NSObjects/LBCustemPresentTransitions'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHPayWaysSelectVC/**/*'
    end
    
    ss.subspec 'QHAlertController' do |sss|
      sss.dependency 'CommonComponents/UIViewControllers/LBAlertController'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHAlertController/**/*'
    end

    ss.subspec 'QHQRViewController' do |sss|
      
      sss.dependency 'QHCommonComponents/QHUIViewControllers/UIViewController+SVProgressHUD'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHQRViewController/**/*'
    end
  end


  #pod spec lint  --use-libraries

end
