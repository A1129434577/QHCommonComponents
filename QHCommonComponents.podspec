Pod::Spec.new do |s|
  s.name             = 'QHCommonComponents'
  s.version          = '0.2.1'
  s.summary          = 'QHCommonComponents of QHWL project.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'A1129434577' => '1129434577@qq.com' }
  s.source           = { :git => "https://github.com/A1129434577/QHCommonComponents.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

 
  s.subspec 'QHMacros' do |ss|
    ss.dependency 'LBCommonComponents/Macros'

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
      sss.dependency 'LBCommonComponents/NSObjects/LBEncrypt'
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHEncryptHelper/**/*'
    end
    
    ss.subspec 'QHBluetooth' do |sss|
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHBluetooth/**/*.{h,m}'
      sss.resource = 'QHCommonComponents/QHNSObjects/QHBluetooth/**/*.mp3'
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

  s.subspec 'QHUIViews' do |ss|
    ss.dependency 'QHCommonComponents/QHMacros'

    ss.subspec 'QHBLEStatusView' do |sss|
      sss.source_files = 'QHCommonComponents/QHUIViews/QHBLEStatusView/**/*.{h,m}'
      sss.resource = 'QHCommonComponents/QHUIViews/QHBLEStatusView/**/*.png'
    end

    ss.subspec 'QHMapView' do |sss|
      sss.source_files = 'QHCommonComponents/QHUIViews/QHMapView/**/*.{h,m}'
      sss.resource = 'QHCommonComponents/QHUIViews/QHMapView/**/*.png'
    end

  end

  s.subspec 'QHUIViewControllers' do |ss|
    ss.dependency 'QHCommonComponents/QHMacros'

    ss.subspec 'QHPayWaysSelectVC' do |sss|
      sss.dependency 'SDWebImage'
      sss.dependency 'LBCommonComponents/NSObjects/LBCustemPresentTransitions'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHPayWaysSelectVC/**/*.{h,m}'
      sss.resource = 'QHCommonComponents/QHUIViewControllers/QHPayWaysSelectVC/**/*.png'
    end
    
    ss.subspec 'QHAlertController' do |sss|
      sss.dependency 'LBCommonComponents/UIViewControllers/LBAlertController'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHAlertController/**/*'
    end

    ss.subspec 'QHQRViewController' do |sss|
      
      sss.dependency 'QHCommonComponents/QHNSObjects/NSObject+SVProgressHUD'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHQRViewController/**/*.{h,m}'
      sss.resource = 'QHCommonComponents/QHUIViewControllers/QHQRViewController/**/*.png'
    end
  end


  #pod spec lint  --use-libraries

end
