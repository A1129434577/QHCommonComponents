//
//  LBUIMacro.h
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/2/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#ifndef LBUIMacro_h
#define LBUIMacro_h

#define UIColorRGBA(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define UIColorRGB(R, G, B)  UIColorRGBA(R,G,B,1.0)
#define UIColorRGBHex(rgbValue) UIColorRGB(((rgbValue & 0xFF0000) >> 16), ((rgbValue & 0x00FF00) >> 8), (rgbValue & 0x0000FF))

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#endif /* LBUIMacro_h */
