//
//  DropDownViewController.h
//  moonbox
//
//  Created by 刘彬 on 2019/1/8.
//  Copyright © 2019 张琛. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#define DropDownViewCELL_HEIGHT 44

@protocol LBSelectItemsProtocol <NSObject>
@required
@property (nonatomic,strong)NSString *title;

@end

@interface LBItemsSelectViewController : UIViewController
@property (nonatomic,strong,readonly)UIPopoverPresentationController *popPC;
@property (nonatomic,strong)NSArray<NSObject<LBSelectItemsProtocol> *> *items;
@property (nonatomic,copy)void(^selectedItem)(NSObject<LBSelectItemsProtocol> *item);

@end

@interface LBItems : NSObject <LBSelectItemsProtocol>
@property (nonatomic,strong)NSString *title;
@end
NS_ASSUME_NONNULL_END
