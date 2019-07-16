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
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:status];
}
- (void)showSuccessWithStatus:(NSString *_Nullable)status{
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:^{
        [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    }];
}
- (void)showSuccessWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion{
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:^{
        completion?completion():NULL;
        [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    }];
}

- (void)showErrorWithStatus:(NSString*)status {
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:^{
        [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    }];
}

- (void)showErrorWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion{
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = NO;
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD dismissWithDelay:[SVProgressHUD displayDurationForString:status] completion:^{
        completion?completion():NULL;
        [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    }];
}

- (void)dismiss{
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];
}
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion{
    [NSObject topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController].view.userInteractionEnabled = YES;
    [SVProgressHUD dismissWithCompletion:completion];
}


+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootVC
{
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)rootVC;
        return (UIViewController *)[self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController*)rootVC;
        return (UIViewController *)[self topViewControllerWithRootViewController:(UIViewController *)navigationController.visibleViewController];
    } else if (rootVC.presentedViewController) {
        UIViewController *presentedViewController = (UIViewController *)rootVC.presentedViewController;
        return (UIViewController *)[self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootVC;
    }
}
@end
