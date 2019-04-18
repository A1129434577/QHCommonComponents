//
//  QHBLEStatusView.h
//  QHBranch
//
//  Created by 刘彬 on 2019/2/28.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, QHBLEStatus) {
    QHBLENotConnect = 0,//未连接
    QHBLEConnecting,
    QHBLEConnected,
    QHBLEDisconnect,//链接失败
};
@interface QHBLEStatusView : UIView

@property (nonatomic,strong)NSString *deviceNo;
@property (nonatomic,assign)NSInteger battery;
@property (nonatomic,assign)QHBLEStatus state;
@property (nonatomic,copy)void(^reConnect)(void);
@end

NS_ASSUME_NONNULL_END
