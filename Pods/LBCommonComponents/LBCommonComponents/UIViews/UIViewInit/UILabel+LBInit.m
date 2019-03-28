//
//  UILabel+init.m
//  QHBranch
//
//  Created by 刘彬 on 2018/12/25.
//  Copyright © 2018 BIN. All rights reserved.
//

#import "UILabel+LBInit.h"

@implementation UILabel (LBInit)
- (instancetype)initWithFrame:(CGRect)frame textColor:( UIColor * _Nullable)textColor
{
    self = [[self.class alloc] initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.adjustsFontSizeToFitWidth = YES;
        self.numberOfLines = 0;
    }
    return self;
}

@end
