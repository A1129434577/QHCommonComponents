//
//  QRViewController.h
//  mbp_purse
//
//  Created by 刘彬 on 16/7/26.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRView.h"
@interface QRViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)QRView *qrView;
@property (nonatomic,copy)void(^QRViewScanedCode)(NSString *qrCode);
- (instancetype)initError:(NSError **)outError;

@end
