//
//  UIButton+init.h
//  QHBranch
//
//  Created by 刘彬 on 2018/12/20.
//  Copyright © 2018 BIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LBInit)
@property (nonatomic,copy)void (^action)(UIButton *sender);
- (instancetype)initWithFrame:(CGRect)frame action:(void (^_Nullable)(UIButton *sender))action;
@end

NS_ASSUME_NONNULL_END
