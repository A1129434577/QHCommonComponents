//
//  UIView+init.m
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/2/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "UIView+init.h"

@implementation UIView (init)
- (id)copy{
    if (@available(iOS 11.0, *)) {
        NSData *selfData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
        return [NSKeyedUnarchiver unarchivedObjectOfClass:self.class fromData:selfData error:nil];
    } else {
        NSData *selfData = [NSKeyedArchiver archivedDataWithRootObject:self];
        return [NSKeyedUnarchiver unarchiveObjectWithData:selfData];
    }
}
@end
