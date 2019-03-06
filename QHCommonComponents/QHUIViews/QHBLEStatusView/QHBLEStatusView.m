//
//  QHBLEStatusView.m
//  QHBranch
//
//  Created by 刘彬 on 2019/2/28.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "QHBLEStatusView.h"
#import "UIButton+init.h"

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
@property (nonatomic,strong)UILabel *promptLabel;

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
        
        WEAKSELF
        _reconnectButton = [[UIButton alloc] initWithFrame:CGRectZero action:^(UIButton * _Nonnull __weak sender) {
            weakSelf.reConnect?weakSelf.reConnect():NULL;
        }];
        [_reconnectButton setTitleColor:THEME_GREEN forState:UIControlStateNormal];
        _reconnectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_reconnectButton setImage:QHBLE_RCONNECT_IMAGE forState:UIControlStateNormal];
        [_reconnectButton setTitle:@"重新连接开锁器" forState:UIControlStateNormal];
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.text = @"请将开锁器放在盒子锁扣处感应";
        
        [self addSubview:_contentBgView];
        [_contentBgView addSubview:_statusImageView];
        [_contentBgView addSubview:_statusLabel];
        [_contentBgView addSubview:_batteryView];
        [_contentBgView addSubview:_promptLabel];
        [_contentBgView addSubview:_reconnectButton];

        
        self.state = QHBLENotConnect;
    }
    return self;
}

-(void)setBattery:(NSInteger)battery{
    _battery = battery;
    [_batteryView setTitle:[NSString stringWithFormat:@"电量：%d%%",battery] forState:UIControlStateNormal];
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
                
                weakSelf.batteryView.frame = weakSelf.reconnectButton.frame = weakSelf.promptLabel.frame = CGRectZero;
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
                
                weakSelf.batteryView.frame = weakSelf.reconnectButton.frame = weakSelf.promptLabel.frame = CGRectZero;
            }
                break;
            case QHBLEConnected:
            {
                weakSelf.statusImageView.image = QHBLE_CONNECTED_IMAGE;
                weakSelf.statusLabel.textColor = THEME_GREEN;
                weakSelf.statusLabel.text = @"开锁器已连接";
                [weakSelf.batteryView setTitle:[NSString stringWithFormat:@"电量：%d%%",weakSelf.battery] forState:UIControlStateNormal];
                
                
                contentBgViewHeight += STATUS_LABEL_HEIGHT*2;
                
                weakSelf.contentBgView.frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-contentBgViewHeight)/2, CGRectGetWidth(self.bounds), contentBgViewHeight);
                weakSelf.statusImageView.frame = CGRectMake((CGRectGetWidth(weakSelf.contentBgView.bounds)-statusImageViewHeight)/2, 0, statusImageViewHeight, statusImageViewHeight);
                
                weakSelf.promptLabel.frame = CGRectMake(0, contentBgViewHeight-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
                weakSelf.batteryView.frame = CGRectMake(0, CGRectGetMinY(weakSelf.promptLabel.frame)-STATUS_LABEL_HEIGHT, CGRectGetWidth(weakSelf.contentBgView.bounds), STATUS_LABEL_HEIGHT);
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
                weakSelf.batteryView.frame = weakSelf.promptLabel.frame = CGRectZero;
            }
                break;
                
            default:
                break;
        }
        
        
    });
    
    
    
    

}
@end

