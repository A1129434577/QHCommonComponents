//
//  UIButton+init.m
//  QHBranch
//
//  Created by 刘彬 on 2018/12/20.
//  Copyright © 2018 BIN. All rights reserved.
//

#import "UIButton+init.h"
#import <objc/runtime.h>

@implementation UIButton (init)
@dynamic action;
static NSString *actionKey = @"actionKey";
- (instancetype)initWithFrame:(CGRect)frame action:(void (^ _Nullable)(__weak UIButton *sender))action;
{
    self = [[self.class alloc] initWithFrame:frame];
    if (self) {
        self.action = action;
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
-(void (^)(UIButton * _Nonnull))action{
    return objc_getAssociatedObject(self, &actionKey);
}
-(void)setAction:(void (^)(__weak UIButton * _Nonnull))action{
    objc_setAssociatedObject(self, &actionKey, action, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonAction{
    self.action?self.action(self):NULL;
}



@end
