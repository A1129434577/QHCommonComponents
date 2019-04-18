//
//  QHBLEStatusView.m
//  QHBranch
//
//  Created by 刘彬 on 2019/2/28.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "QHBLEStatusView.h"

#define QHBLE_DISCONNECT_IMAGE [UIImage imageNamed:@"ble_locker_disconnect"]
#define QHBLE_CONNECTING_IMAGE [UIImage imageNamed:@"ble_locker_connection"]
#define QHBLE_CONNECTED_IMAGE [UIImage imageNamed:@"ble_locker_connected"]
#define QHBLE_BATTERY_IMAGE [UIImage imageNamed:@"battery"]
#define QHBLE_RCONNECT_IMAGE [UIImage imageNamed:@"ble_refresh"]

#define STATUS_LABEL_HEIGHT 20

@interface QHBLEStatusView()
@property (nonatomic,strong)UIView *contentBgView;
@property (nonatomic,strong)UIImageView *statusImageView;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIButton *batteryView;
@property (nonatomic,strong)UIButton *reconnectButton;
@property (nonatomic,strong)UILabel *deviceNoLabel;

@end

@implementation QHBLEStatusView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentBgView = [[UIView alloc] init];
        
        _statusImageView = [[UIImageView alloc] init];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        
        _batteryView = [[UIButton alloc] init];
        _batteryView.titleLabel.font = [UIFont systemFontOfSize:14];
        [_batteryView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _batteryView.enabled = NO;
        [_batteryView setImage:QHBLE_BATTERY_IMAGE forState:UIControlStateNormal];
        
        _reconnectButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_reconnectButton addTarget:self action:@selector(reconnectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_reconnectButton setTitleColor:THEME_GREEN forState:UIControlStateNormal];
        _reconnectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_reconnectButton setImage:QHBLE_RCONNECT_IMAGE forState:UIControlStateNormal];
        [_reconnectButton setTitle:@"重新连接开锁器" forState:UIControlStateNormal];
        
        _deviceNoLabel = [[UILabel alloc] init];
        _deviceNoLabel.textAlignment = NSTextAlignmentCenter;
        _deviceNoLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_contentBgView];
        [_contentBgView addSubview:_statusImageView];
        [_contentBgView addSubview:_statusLabel];
        [_contentBgView addSubview:_batteryView];
        [_contentBgView addSubview:_deviceNoLabel];
        [_contentBgView addSubview:_reconnectButton];

        
        self.state = QHBLENotConnect;
    }
    return self;
}
-(void)setDeviceNo:(NSString *)deviceNo{
    _deviceNo = deviceNo;
    _deviceNoLabel.text = [NSString stringWithFormat:@"开锁器编号：%@",deviceNo];
}
-(void)setBattery:(NSInteger)battery{
    _battery = battery;
    [_batteryView setTitle:[NSString stringWithFormat:@"电量：%ld%%",(long)battery] forState:UIControlStateNormal];
}
-(void)setState:(QHBLEStatus)state{
    _state = state;
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat statusImageViewHeight = CGRectGetHeight(self.bounds)-(STATUS_LABEL_HEIGHT*3+15);
        if (statusImageViewHeight>160) {
            statusImageViewHeight = 160;
        }
        CGFloat contentBgViewHeight = statusImageViewHeight+STATUS_LABEL_HEIGHT+15;
        
        
        
        switch (state) {
            case QHBLENotConnect:
            {
                weakSelf.statusImageView.image = QHBLE_DISCONNECT_IMAGE;
                weakSelf.statusLabel.textColor = [UIColor redColor];
                weakSelf.statusLabel.text = @"开锁器未连接";
                
                weakSelf.contentBgView.frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-contentBgViewHeight)/2, CGRectGetWidth(self.bounds), contentBgViewHeight);
                weakSelf.statusImageView.frame = CGRectMake((CGRectGetWidth(weakSelf.contentBgView.bounds)-statusImageViewHeight)/2, 0, statusImageViewHeight, statusImageViewHeight);
                
                
                weakSelf.statusLabel.frame = CGRectMake(0, contentBgViewHeight-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                
                weakSelf.batteryView.frame = weakSelf.reconnectButton.frame = weakSelf.deviceNoLabel.frame = CGRectZero;
            }
                break;
            case QHBLEConnecting:
            {
                weakSelf.statusImageView.image = QHBLE_CONNECTING_IMAGE;
                weakSelf.statusLabel.textColor = THEME_GREEN;
                weakSelf.statusLabel.text = @"开锁器连接中...";
                
                weakSelf.contentBgView.frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-contentBgViewHeight)/2, CGRectGetWidth(self.bounds), contentBgViewHeight);
                weakSelf.statusImageView.frame = CGRectMake((CGRectGetWidth(weakSelf.contentBgView.bounds)-statusImageViewHeight)/2, 0, statusImageViewHeight, statusImageViewHeight);
                
                weakSelf.statusLabel.frame = CGRectMake(0, contentBgViewHeight-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                
                weakSelf.batteryView.frame = weakSelf.reconnectButton.frame = weakSelf.deviceNoLabel.frame = CGRectZero;
            }
                break;
            case QHBLEConnected:
            {
                weakSelf.statusImageView.image = QHBLE_CONNECTED_IMAGE;
                weakSelf.statusLabel.textColor = THEME_GREEN;
                weakSelf.statusLabel.text = @"开锁器蓝牙连接成功";
                [weakSelf.batteryView setTitle:[NSString stringWithFormat:@"电量：%ld%%",(long)weakSelf.battery] forState:UIControlStateNormal];
                
                
                contentBgViewHeight += STATUS_LABEL_HEIGHT*2;
                
                weakSelf.contentBgView.frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-contentBgViewHeight)/2, CGRectGetWidth(self.bounds), contentBgViewHeight);
                weakSelf.statusImageView.frame = CGRectMake((CGRectGetWidth(weakSelf.contentBgView.bounds)-statusImageViewHeight)/2, 0, statusImageViewHeight, statusImageViewHeight);
                
                weakSelf.deviceNoLabel.frame = CGRectMake(0, contentBgViewHeight-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                weakSelf.batteryView.frame = CGRectMake(0, CGRectGetMinY(weakSelf.deviceNoLabel.frame)-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                weakSelf.statusLabel.frame = CGRectMake(0, CGRectGetMinY(weakSelf.batteryView.frame)-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                
                weakSelf.reconnectButton.frame = CGRectZero;
                
                
            }
                break;
            case QHBLEDisconnect:
            {
                weakSelf.statusImageView.image = QHBLE_DISCONNECT_IMAGE;
                weakSelf.statusLabel.textColor = [UIColor redColor];
                weakSelf.statusLabel.text = @"开锁器已断开";
                
                contentBgViewHeight += STATUS_LABEL_HEIGHT;
                
                weakSelf.contentBgView.frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-contentBgViewHeight)/2, CGRectGetWidth(self.bounds), contentBgViewHeight);
                weakSelf.statusImageView.frame = CGRectMake((CGRectGetWidth(weakSelf.contentBgView.bounds)-statusImageViewHeight)/2, 0, statusImageViewHeight, statusImageViewHeight);
                
                weakSelf.reconnectButton.frame = CGRectMake(0, contentBgViewHeight-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                
                weakSelf.statusLabel.frame = CGRectMake(0, CGRectGetMinY(weakSelf.reconnectButton.frame)-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                weakSelf.batteryView.frame = weakSelf.deviceNoLabel.frame = CGRectZero;
            }
                break;
                
            default:
                break;
        }
        
        
    });
}

-(void)reconnectButtonAction{
    self.reConnect?self.reConnect():NULL;
}
@end

