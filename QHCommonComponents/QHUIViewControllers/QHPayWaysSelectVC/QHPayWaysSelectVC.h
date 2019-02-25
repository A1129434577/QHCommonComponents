//
//  PayWaysViewController.h
//  moonbox
//
//  Created by 刘彬 on 2018/11/29.
//  Copyright © 2018 张琛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PayWayObjectProtocol <NSObject>
@required
@property (nonatomic,strong)NSString *payName;
@property (nonatomic,strong)NSString *iconUrl;
@property (nonatomic,strong)NSString *payType;
@end

@interface QHPayWayObject : NSObject <PayWayObjectProtocol>
@property (nonatomic,strong)NSString *payName;
@property (nonatomic,strong)NSString *iconUrl;
@property (nonatomic,strong)NSString *payType;
@end

@interface QHPayWaysSelectVC : UIViewController

@property (nonatomic,copy)void (^payWaySelected)(id<PayWayObjectProtocol>);

- (instancetype)initWithPayWays:(NSArray<id<PayWayObjectProtocol>> *)payWays title:(NSString *)title subTitle:(NSString *_Nullable)subTitle;
@end

NS_ASSUME_NONNULL_END
