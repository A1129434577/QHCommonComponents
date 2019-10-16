//
//  UIColor+LBConvertToImage.h
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/3/5.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LBToImage)
- (UIImage *)imageWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
