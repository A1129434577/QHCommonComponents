//
//  DropDownViewController.h
//  moonbox
//
//  Created by 刘彬 on 2019/1/8.
//  Copyright © 2019 张琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DropDownViewCELL_HEIGHT 44
NS_ASSUME_NONNULL_BEGIN

@interface LBItemsSelectViewController : UIViewController
@property (nonatomic,strong,readonly)UIPopoverPresentationController *popPC;

@property (nonatomic,strong)NSArray<NSString *> *items;
@property (nonatomic,strong)UIFont *font;
@property(nonatomic)NSTextAlignment textAlignment;
@property (nonatomic,copy)void(^selectedItem)(NSString *item);

@end

NS_ASSUME_NONNULL_END
