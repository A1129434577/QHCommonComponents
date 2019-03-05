//
//  QRView.m
//  test
//
//  Created by 刘彬 on 16/7/25.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "QRView.h"

#define BOX_WIDTH 250

@interface QRView ()
{
    AVCaptureDevice *_device;
    UIButton *_lightenBtn;
}
@end


@implementation QRView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AVCaptureMetadataOutputObjectsDelegate> )delegate error:(NSError **)outError
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            *outError = [NSError errorWithDomain:@"error" code:1111 userInfo:@{NSLocalizedDescriptionKey:@"您的设备不支持相机"}];
            return nil;
        }else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] != AVAuthorizationStatusAuthorized && [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] != AVAuthorizationStatusNotDetermined) {
            *outError = [NSError errorWithDomain:@"error" code:1112 userInfo:@{NSLocalizedDescriptionKey:@"相机调用受限,请在隐私设置中启用相机访问"}];
            return nil;
        }
        
        
        
        CGRect BOX_FRAME = CGRectMake((CGRectGetWidth(self.bounds)-BOX_WIDTH)/2, (CGRectGetHeight(self.bounds)-BOX_WIDTH)/2, BOX_WIDTH, BOX_WIDTH);
        if (CGRectGetMinY(BOX_FRAME)<20) {
            BOX_FRAME.origin.y = 20;;
        }
        
        
        
        
        
        UIView *boxView = [[UIView alloc] initWithFrame:BOX_FRAME];
        boxView.clipsToBounds = YES;
        boxView.layer.cornerRadius = 5;
        [self.layer addSublayer:boxView.layer];
        //另外样式的扫描线
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -CGRectGetHeight(BOX_FRAME), CGRectGetWidth(BOX_FRAME), CGRectGetHeight(BOX_FRAME))];
//        imageView.image = [UIImage imageNamed:@"scan"];
//        [boxView.layer addSublayer:imageView.layer];
        
        
        CAGradientLayer *layer = [CAGradientLayer new];
        layer.frame = CGRectMake(CGRectGetMinX(boxView.frame), CGRectGetMinY(boxView.frame), CGRectGetWidth(boxView.frame), 3);
        layer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)THEME_GREEN.CGColor,(__bridge id)THEME_GREEN.CGColor,(__bridge id)[UIColor clearColor].CGColor];
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(1, 1);
        [self.layer addSublayer:layer];
        
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];//变化模式
        basicAnimation.fromValue = [NSNumber numberWithFloat:0];//开始
        basicAnimation.toValue = [NSNumber numberWithFloat:CGRectGetHeight(boxView.frame)];//结束
        basicAnimation.duration = 1.5;//变化时间
        
        basicAnimation.repeatCount = NSUIntegerMax;//重复次数
        basicAnimation.removedOnCompletion = NO;
        [layer addAnimation:basicAnimation forKey:@"labelAnimateLayer"];//可以通过KEY去找它究竟是它哪一个动画
        
        
        //边框画线*******************************************
        CGFloat lineLenth = 20,radius = 5;
        CGPoint point1 = CGPointMake(0, radius);//左上角左边的点(一下点逆时针排列)
        CGPoint point1_1 = CGPointMake(0, lineLenth);
        CGPoint point2 = CGPointMake(0, CGRectGetHeight(BOX_FRAME)-lineLenth);
        CGPoint point2_1 = CGPointMake(0, CGRectGetHeight(BOX_FRAME)-radius);
        CGPoint point3 = CGPointMake(radius, CGRectGetHeight(BOX_FRAME));
        CGPoint point3_1 = CGPointMake(lineLenth, CGRectGetHeight(BOX_FRAME));
        CGPoint point4 = CGPointMake(CGRectGetWidth(BOX_FRAME)-lineLenth, CGRectGetHeight(BOX_FRAME));
        CGPoint point4_1 = CGPointMake(CGRectGetWidth(BOX_FRAME)-radius, CGRectGetHeight(BOX_FRAME));
        CGPoint point5 = CGPointMake(CGRectGetWidth(BOX_FRAME), CGRectGetHeight(BOX_FRAME)-radius);
        CGPoint point5_1 = CGPointMake(CGRectGetWidth(BOX_FRAME), CGRectGetHeight(BOX_FRAME)-lineLenth);
        
        CGPoint point6 = CGPointMake(CGRectGetWidth(BOX_FRAME), lineLenth);
        CGPoint point6_1 = CGPointMake(CGRectGetWidth(BOX_FRAME), radius);
        
        CGPoint point7 = CGPointMake(CGRectGetWidth(BOX_FRAME)-radius, 0);
        CGPoint point7_1 = CGPointMake(CGRectGetWidth(BOX_FRAME)-lineLenth, 0);
        
        CGPoint point8 = CGPointMake(lineLenth, 0);
        CGPoint point8_1 = CGPointMake(radius, 0);
        
        CGPoint controlPoint1 = CGPointMake(0, 0);
        CGPoint controlPoint2 = CGPointMake(CGRectGetWidth(BOX_FRAME), 0);
        CGPoint controlPoint3 = CGPointMake(CGRectGetWidth(BOX_FRAME), CGRectGetHeight(BOX_FRAME));
        CGPoint controlPoint4 = CGPointMake(0, CGRectGetHeight(BOX_FRAME));
        
        
        UIBezierPath *path =  [[UIBezierPath alloc] init];
        [path moveToPoint:point1_1];
        [path addLineToPoint:point2];
        
        [path moveToPoint:point3_1];
        [path addLineToPoint:point4];
        
        [path moveToPoint:point5_1];
        [path addLineToPoint:point6];
        
        [path moveToPoint:point7_1];
        [path addLineToPoint:point8];
        
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.path = path.CGPath;
        [boxView.layer addSublayer:shapeLayer];
        
        
        UIBezierPath *path2 =  [[UIBezierPath alloc] init];
        [path2 moveToPoint:point1_1];
        [path2 addLineToPoint:point1];
        [path2 addQuadCurveToPoint:point8_1 controlPoint:controlPoint1];
        [path2 addLineToPoint:point8];
        
        [path2 moveToPoint:point7_1];
        [path2 addLineToPoint:point7];
        [path2 addQuadCurveToPoint:point6_1 controlPoint:controlPoint2];
        [path2 addLineToPoint:point6];
        
        
        [path2 moveToPoint:point5_1];
        [path2 addLineToPoint:point5];
        [path2 addQuadCurveToPoint:point4_1 controlPoint:controlPoint3];
        [path2 addLineToPoint:point4];
        
        
        [path2 moveToPoint:point3_1];
        [path2 addLineToPoint:point3];
        [path2 addQuadCurveToPoint:point2_1 controlPoint:controlPoint4];
        [path2 addLineToPoint:point2];
        
        CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
        shapeLayer2.strokeColor = THEME_GREEN.CGColor;
        shapeLayer2.fillColor = [UIColor clearColor].CGColor;
        shapeLayer2.lineWidth = 4;
        shapeLayer2.path = path2.CGPath;
        [boxView.layer addSublayer:shapeLayer2];
        
        
        UIBezierPath *path3 =  [[UIBezierPath alloc] init];
        
        [path3 moveToPoint:CGPointMake(0, 0)];
        [path3 addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
        [path3 addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [path3 addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
        [path3 addLineToPoint:CGPointMake(0, 0)];
        
        
        [path3 moveToPoint:[self convertPoint:point1 fromView:boxView]];
        [path3 addLineToPoint:[self convertPoint:point2_1 fromView:boxView]];
        [path3 addQuadCurveToPoint:[self convertPoint:point3 fromView:boxView] controlPoint:[self convertPoint:controlPoint4 fromView:boxView]];
        
        [path3 addLineToPoint:[self convertPoint:point4_1 fromView:boxView]];
        [path3 addQuadCurveToPoint:[self convertPoint:point5 fromView:boxView] controlPoint:[self convertPoint:controlPoint3 fromView:boxView]];
        
        [path3 addLineToPoint:[self convertPoint:point6_1 fromView:boxView]];
        [path3 addQuadCurveToPoint:[self convertPoint:point7 fromView:boxView] controlPoint:[self convertPoint:controlPoint2 fromView:boxView]];
        
        [path3 addLineToPoint:[self convertPoint:point8_1 fromView:boxView]];
        [path3 addQuadCurveToPoint:[self convertPoint:point1 fromView:boxView] controlPoint:[self convertPoint:controlPoint1 fromView:boxView]];
        
        
        
        CAShapeLayer *shapeLayer3 = [CAShapeLayer layer];
        shapeLayer3.strokeColor = [UIColor clearColor].CGColor;

        shapeLayer3.fillColor = UIColorRGBAHex(0x232a50,0.8).CGColor;
        shapeLayer3.fillRule = kCAFillRuleEvenOdd;
        shapeLayer3.path = path3.CGPath;
        [self.layer addSublayer:shapeLayer3];
        //******************************************
        
        
        
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-180)/2, CGRectGetMinY(BOX_FRAME)-50, 180, 20)];
        promptLabel.clipsToBounds = YES;
        promptLabel.layer.cornerRadius = CGRectGetHeight(promptLabel.frame)/2;
        promptLabel.backgroundColor = [UIColor whiteColor];
        promptLabel.textColor = [UIColor blackColor];
        promptLabel.text = @"将二维码/条码放入框内";
        promptLabel.font = [UIFont systemFontOfSize:14];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:promptLabel];
        
        
        _lightenBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-70)/2, CGRectGetMaxY(BOX_FRAME)+8, 70, 50)];
        _lightenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 20, 20);
        _lightenBtn.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(_lightenBtn.frame)-20, -CGRectGetWidth(_lightenBtn.frame)+20, -5, 0);
        [_lightenBtn setImage:[UIImage imageNamed:@"lighten_s"] forState:UIControlStateSelected];
        [_lightenBtn setImage:[UIImage imageNamed:@"lighten"] forState:UIControlStateNormal];
        _lightenBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_lightenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lightenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_lightenBtn setTitle:@"轻触开灯" forState:UIControlStateNormal];
        [_lightenBtn setTitle:@"轻触关灯" forState:UIControlStateSelected];
        [_lightenBtn addTarget:self action:@selector(lighten:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lightenBtn];
        _lightenBtn.hidden = YES;
        
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = CGPointMake(CGRectGetMinX(BOX_FRAME)+CGRectGetWidth(BOX_FRAME)/2, CGRectGetMinY(BOX_FRAME)+CGRectGetHeight(BOX_FRAME)/2);
        [activityView startAnimating];
        [self addSubview:activityView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
            
            // 1. 实例化拍摄设备
            self->_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            // 2. 设置输入设备
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self->_device error:&error];
            if (error) {
                *outError = error;
            }
            
            // 3. 设置元数据输出
            // 3.1 实例化拍摄元数据输出
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            // 3.3 设置输出数据代理
            [output setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
            
            // 3.4创建灯光设备输出流
            AVCaptureVideoDataOutput *lamplightOutput = [[AVCaptureVideoDataOutput alloc] init];
            [lamplightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
            
            // 4. 添加拍摄会话
            // 4.1 实例化拍摄会话
            self->_session = [[AVCaptureSession alloc] init];
            
            // 4.2 添加会话输入
            [self->_session addInput:input];
            
            // 4.3 添加会话输出
            [self->_session addOutput:output];
            [self->_session addOutput:lamplightOutput];
            
            // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,//二维码
                                         //以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypePDF417Code];
            
            
            
            // 5. 视频预览图层
            // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
            AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self->_session];
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            preview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
            
            // 6. 启动会话
            [self->_session startRunning];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [activityView stopAnimating];
                
                //将图层插入当前视图
                [self.layer insertSublayer:preview atIndex:0];
                
            });
        });
        
        
    }
    return self;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    // brightnessValue 值代表光线强度，值越小代表光线越暗
    if (_device.hasTorch && (_device.torchMode == AVCaptureTorchModeOff)) {
        if ((_lightenBtn.alpha == 0) || (_lightenBtn.alpha == 1)) {
            self->_lightenBtn.hidden = !(brightnessValue <= -3);
            [UIView animateWithDuration:0.5 animations:^{
                self->_lightenBtn.alpha = !self->_lightenBtn.hidden;
            }];
        }
        
        
    }
}
-(void)lighten:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _lightenBtn.hidden = NO;
    }
    [self torchMode];
}

-(void)torchMode{
    if (self->_device.hasTorch) {
    NSError *error = nil;
    [_device lockForConfiguration:&error];
    if (error == nil) {
        AVCaptureTorchMode mode = _device.torchMode;
        _device.torchMode = mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
    }
    [_device unlockForConfiguration];
    }
}



@end
