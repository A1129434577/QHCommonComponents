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

- (void)showErrorWithStatus:(NSString*)status;

- (void)dismiss;
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion;
- (void)showSuccessWithStatus:(NSString *)status completion:(SVProgressHUDDismissCompletion)completion;
/** 显示错误错误提示 */
- (void)dismissErrorWithTitle:(NSString *)title completion:(SVProgressHUDDismissCompletion)completion;
/** 显示成功 */
- (void)showSuccessWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
