//
//  NSObject+SVProgressHUD.h
//  QHCommonComponentsExample
//
//  Created by 刘彬 on 2019/2/28.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SVProgressHUD)
- (void)showWithStatus:(NSString *_Nullable)status;
- (void)showSuccessWithStatus:(NSString *_Nullable)status;
- (void)showSuccessWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion;

- (void)showErrorWithStatus:(NSString *_Nullable)status;
- (void)showErrorWithStatus:(NSString *_Nullable)status completion:(SVProgressHUDDismissCompletion)completion;

- (void)dismiss;
- (void)dismissWithCompletion:(SVProgressHUDDismissCompletion)completion;
@end

NS_ASSUME_NONNULL_END
