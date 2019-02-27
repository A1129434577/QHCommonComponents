//
//  UIViewController+SVProgressHUD.h
//  moonbox
//
//  Created by 刘彬 on 2018/11/20.
//  Copyright © 2018 张琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SVProgressHUD)
- (void)showWithStatus:(NSString *_Nullable)status;
- (void)showSuccessWithStatus:(NSString *_Nullable)status;
- (void)showSuccessWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion;

- (void)showErrorWithStatus:(NSString *_Nullable)status;
- (void)showErrorWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion;

- (void)dismiss;
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
