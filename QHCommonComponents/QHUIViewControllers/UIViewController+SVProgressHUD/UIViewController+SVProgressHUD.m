//
//  UIViewController+SVProgressHUD.m
//  moonbox
//
//  Created by 刘彬 on 2018/11/20.
//  Copyright © 2018 张琛. All rights reserved.
//

#import "UIViewController+SVProgressHUD.h"
@implementation UIViewController (SVProgressHUD)
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    id obj = [super allocWithZone:zone];
    if ([obj isKindOfClass:UIViewController.self]) {
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(SVProgressHUDWillAppear) name:SVProgressHUDWillAppearNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(SVProgressHUDDidDisappear) name:SVProgressHUDDidDisappearNotification object:nil];
    }
    
    return obj;
}


- (void)showWithStatus:(NSString*)status {
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:status];
}

- (void)showErrorWithStatus:(NSString*)status {
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:status];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion{
    [SVProgressHUD dismissWithCompletion:completion];
}

- (void)showSuccessWithStatus:(NSString *)status completion:(SVProgressHUDDismissCompletion)completion {
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:completion];
}

/** 显示错误错误提示 */
- (void)dismissErrorWithTitle:(NSString *)title completion:(SVProgressHUDDismissCompletion)completion {
    [SVProgressHUD showErrorWithStatus:title];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:title] completion:completion];
}

/** 显示成功 */
- (void)showSuccessWithTitle:(NSString *)title {
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:title];
}
-(void)SVProgressHUDWillAppear{
    self.view.userInteractionEnabled = NO;
}
-(void)SVProgressHUDDidDisappear{
    self.view.userInteractionEnabled = YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
