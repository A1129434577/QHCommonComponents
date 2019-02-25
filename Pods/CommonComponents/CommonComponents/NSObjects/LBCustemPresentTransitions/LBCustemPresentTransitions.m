//
//  ViewController.m
//  test
//
//  Created by 刘彬 on 16/7/1.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBCustemPresentTransitions.h"

@interface LBCustemPresentTransitions ()
@property (nonatomic,strong)UIView *coverView;;
@end

@implementation LBCustemPresentTransitions

+(LBCustemPresentTransitions *)shareInstanse{
    static LBCustemPresentTransitions *modelAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelAnimation = [[LBCustemPresentTransitions alloc] init];
    });
    return modelAnimation;
}

#pragma mark - UIViewControllerAnimatedTransitioning
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //The view controller's view that is presenting the modal view
    UIView *containerView = [transitionContext containerView];
    
    UINavigationController *modalViewVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *contentView;
    if ([modalViewVC isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        contentView = modalViewVC.topViewController.view;
    }else if ([modalViewVC isKindOfClass:NSClassFromString(@"UIViewController")]){
        contentView = modalViewVC.view;
    }
    
    

    if (self.type == AnimationTypePresent) {
        
        //View to darken the area behind the modal view
        if (!_coverView) {
            _coverView = [[UIView alloc] initWithFrame:containerView.frame];
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            // 磨砂视图
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            effectView.frame = _coverView.bounds;
            effectView.alpha = 0.5;
            [_coverView addSubview:effectView];
        }else{
            _coverView.frame = containerView.frame;
        }
        [containerView addSubview:_coverView];
        
        //The modal view itself
        modalViewVC.view.frame = CGRectMake((CGRectGetWidth(containerView.frame)-CGRectGetWidth(contentView.frame))/2, CGRectGetHeight(containerView.frame), CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
        if (_mbContentMode == MBViewContentModeCenter) {
            modalViewVC.view.frame = CGRectMake(CGRectGetMinX(modalViewVC.view.frame), (CGRectGetHeight(containerView.frame)-CGRectGetHeight(contentView.frame))/2, CGRectGetWidth(modalViewVC.view.frame), CGRectGetHeight(modalViewVC.view.frame));
            modalViewVC.view.transform = CGAffineTransformMakeScale(0, 0);
        }
        [containerView addSubview:modalViewVC.view];
        
        typeof(self) __weak weakSelf = self;
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            if (weakSelf.mbContentMode == MBViewContentModeCenter){
                modalViewVC.view.transform = CGAffineTransformIdentity;
            }else if (weakSelf.mbContentMode == MBViewContentModeBottom) {
                modalViewVC.view.frame = CGRectMake(CGRectGetMinX(modalViewVC.view.frame), CGRectGetHeight(containerView.frame)-CGRectGetHeight(modalViewVC.view.frame), CGRectGetWidth(modalViewVC.view.frame), CGRectGetHeight(modalViewVC.view.frame));
            }
            weakSelf.coverView.alpha = 1.0;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    } else if (self.type == AnimationTypeDismiss) {
        //The modal view itself
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
            weakSelf.coverView.alpha = 0.0;
            if (weakSelf.mbContentMode == MBViewContentModeCenter) {
                modalView.transform = CGAffineTransformMakeScale(0, 0);
            }else if (weakSelf.mbContentMode == MBViewContentModeBottom){
                modalView.frame = CGRectMake(CGRectGetMinX(modalView.frame), CGRectGetHeight(containerView.frame), CGRectGetWidth(modalView.frame), CGRectGetHeight(modalView.frame));
            }
        } completion:^(BOOL finished) {
            [weakSelf.coverView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.type = AnimationTypePresent;
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.type = AnimationTypeDismiss;
    return self;
}

#pragma mark - Navigation Controller Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
    __block CGFloat modelViewHeight = 0.f;
    [toVC.view.subviews enumerateObjectsUsingBlock:^(UIView  *contentView, NSUInteger idx, BOOL * _Nonnull stop) {
        modelViewHeight += CGRectGetHeight(contentView.bounds);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        navigationController.view.frame = CGRectMake(CGRectGetMinX(navigationController.view.frame), (CGRectGetHeight([UIScreen mainScreen].bounds)-modelViewHeight)/2, CGRectGetWidth(navigationController.view.frame), modelViewHeight);
    }];
    
    [toVC loadView];
    
    
    return nil;
}

@end
