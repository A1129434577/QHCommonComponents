//
//  UIImage+Color.h
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/13.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBChangedColor)
/**
 *  用自定义颜色初始化图片
 *
 *  @param color 自定义颜色
 */
- (UIImage *)changedColor:(UIColor *)color;


@end
