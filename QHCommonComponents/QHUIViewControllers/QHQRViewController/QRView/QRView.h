//
//  QRView.h
//  test
//
//  Created by 刘彬 on 16/7/25.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic,strong)AVCaptureSession *session;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AVCaptureMetadataOutputObjectsDelegate> )delegate error:(NSError **)outError;
-(void)torchMode;

@end
