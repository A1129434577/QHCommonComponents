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
  s.source           = { :git => 'https://github.com/A1129434577/QHCommonComponents.git', :tag => s.version.to_s }
  #s.source           = { :git => "/Users/liubin/Desktop/QHCommonComponentsExample", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'


  s.subspec 'UIViewControllers' do |ss|
    ss.subspec 'QHAlertController' do |sss|
      sss.dependency 'CommonComponents/UIViewControllers/LBAlertController', '~> 0.0.1'
      sss.source_files = 'CommonComponents/UIViewControllers/QHAlertController/**/*'
    end
  end


end
