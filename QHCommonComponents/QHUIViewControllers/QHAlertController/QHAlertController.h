//
//  QHAlertController.h
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/2/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "LBAlertController.h"
NS_ASSUME_NONNULL_BEGIN

@interface QHAlertController : LBAlertController
-(LBAlertActionButton *)addActionTitle:(NSString *_Nullable)actionTitle action:(void (^_Nullable)(LBAlertActionButton *_Nonnull sender))action;

@end

NS_ASSUME_NONNULL_END
