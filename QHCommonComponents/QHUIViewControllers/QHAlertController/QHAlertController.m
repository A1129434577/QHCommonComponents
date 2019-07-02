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

-(void)loadView{
    [super loadView];
    
    if (self.alertTitle) {
        UIView *topHLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.alertMessageLabel.frame)+2, CGRectGetWidth(self.view.frame), 0.5)];
        topHLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:topHLineView];
    }
    
}

- (LBAlertActionButton *)addActionTitle:(NSString *)actionTitle action:(void (^)(LBAlertActionButton * _Nonnull))action{
    
    CGFloat actionBtnWidth = CGRectGetWidth(self.view.bounds)/(self.buttonArray.count+1);
    
    [self.buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.bounds = CGRectMake(0, 0, actionBtnWidth, CGRectGetHeight(obj.bounds));
    }];
    
    __weak typeof(self) weakSelf = self;
    LBAlertActionButton *actionBtn = [[LBAlertActionButton alloc] initWithFrame:CGRectMake(0, 0, actionBtnWidth, 40) action:^(LBAlertActionButton *sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            action?action(sender):NULL;
        }];
    }];
    [actionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actionBtn setTitle:actionTitle forState:UIControlStateNormal];
    UIView *actionBtnHline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(actionBtn.frame), 0.5)];
    actionBtnHline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [actionBtn addSubview:actionBtnHline];
    UIView *actionBtnVline = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, 1, CGRectGetHeight(actionBtn.bounds))];
    actionBtnVline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [actionBtn addSubview:actionBtnVline];
    
    
    
    [self addActionButton:actionBtn];
    
    return actionBtn;
}

@end
