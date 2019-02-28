//
//  NSObject+SVProgressHUD.m
//  QHCommonComponentsExample
//
//  Created by 刘彬 on 2019/2/28.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "NSObject+SVProgressHUD.h"

@implementation NSObject (SVProgressHUD)
- (void)showWithStatus:(NSString*)status {
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:status];
    
}
- (void)showSuccessWithStatus:(NSString *_Nullable)status{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:status];
}
- (void)showSuccessWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion{
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:completion];
}

- (void)showErrorWithStatus:(NSString*)status {
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:status];
}

- (void)showErrorWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion{
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:completion];
}

- (void)dismiss{
    [SVProgressHUD dismiss];
}
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion{
    [SVProgressHUD dismissWithCompletion:completion];
}
@end
