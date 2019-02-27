//
//  UIViewController+SVProgressHUD.m
//  moonbox
//
//  Created by 刘彬 on 2018/11/20.
//  Copyright © 2018 张琛. All rights reserved.
//

#import "UIViewController+SVProgressHUD.h"
@implementation UIViewController (SVProgressHUD)
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
