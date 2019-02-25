Pod::Spec.new do |s|
  s.name             = 'QHCommonComponents'
  s.version          = '0.0.1'
  s.summary          = 'QHCommonComponents of QHWL project.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/A1129434577'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'A1129434577' => '1129434577@qq.com' }
  s.source           = { :git => "/Users/liubin/Desktop/QHCommonComponentsExample", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'


  s.subspec 'UIViewControllers' do |ss|
    ss.subspec 'QHAlertController' do |sss|
      sss.dependency 'CommonComponents/QHUIViewControllers/LBAlertController', '~> 0.0.1'
      sss.source_files = 'QHCommonComponents/QHUIViewControllers/QHAlertController/**/*'
    end
  end

  s.subspec 'NSObjects' do |ss|
    ss.subspec 'QHEncryptHelper' do |sss|
      sss.dependency 'CommonComponents/NSObjects/LBEncrypt', '~> 0.0.1'
      sss.source_files = 'QHCommonComponents/QHNSObjects/QHEncryptHelper/**/*'
    end
  end


end
