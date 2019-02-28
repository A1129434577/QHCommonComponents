//
//  QHAlertController.m
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/2/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "QHAlertController.h"
#import "LBUIMacro.h"
@interface QHAlertController ()

@end

@implementation QHAlertController

-(LBAlertActionButton *)addActionTitle:(nonnull NSString *)actionTitle action:(__nullable LBAlertAction)action{
    
    CGFloat actionBtnWidth = CGRectGetWidth(self.view.bounds)/(self.buttonArray.count+1);
    
    [self.buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, 0, actionBtnWidth, 40);
    }];
    
    LBAlertActionButton *actionBtn = [[LBAlertActionButton alloc] initWithFrame:CGRectMake(0, 0, actionBtnWidth, 40) action:^(UIButton *sender) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (action) {
                action(sender,self.userView.userInfo);
            }
        }];
    }];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actionBtn setTitle:actionTitle forState:UIControlStateNormal];
    [self addActionButton:actionBtn];
    
    actionBtn.backgroundColor = UIColorRGBHex(0x10c6bf);
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.buttonArray.count%2 == 0) {
        actionBtn.backgroundColor = UIColorRGBHex(0x10c6bf);
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        actionBtn.backgroundColor = [UIColor whiteColor];
        [actionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return actionBtn;
}

@end
