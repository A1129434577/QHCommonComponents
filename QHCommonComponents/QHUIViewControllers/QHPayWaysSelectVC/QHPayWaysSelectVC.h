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

@interface QHPayWaysCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconView;
@end

@interface QHPayWaysSelectVC : UIViewController
@property (nonatomic,strong,readonly)UILabel *headerMessageLabel;
@property (nonatomic,strong)NSString *headerMessage;
@property (nonatomic,strong,readonly)UILabel *footerMessageLabel;
@property (nonatomic,strong)NSString *footerMessage;
@property (nonatomic,copy)void (^payWaySelected)(id<PayWayObjectProtocol>);

- (instancetype)initWithPayWays:(NSArray<id<PayWayObjectProtocol>> * _Nullable)payWays;
@end

NS_ASSUME_NONNULL_END
