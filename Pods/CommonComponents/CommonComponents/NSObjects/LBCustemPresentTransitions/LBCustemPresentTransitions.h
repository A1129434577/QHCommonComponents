//
//  ViewController.h
//  test
//
//  Created by 刘彬 on 16/7/1.
//  Copyright © 2016年 刘彬. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss,
    AnimationTypePush,
    AnimationTypePop,
} AnimationType;

typedef NS_ENUM(NSInteger, MBViewContentMode) {
    MBViewContentModeBottom = 0,
    MBViewContentModeCenter,
};


@interface LBCustemPresentTransitions : NSObject <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) AnimationType type;
@property (nonatomic, assign) MBViewContentMode mbContentMode;

+(LBCustemPresentTransitions *)shareInstanse;

@end
