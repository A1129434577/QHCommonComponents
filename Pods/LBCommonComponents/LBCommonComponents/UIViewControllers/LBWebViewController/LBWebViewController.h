//
//  AuthsManageViewController.h
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/13.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface LBWebViewController : UIViewController<WKNavigationDelegate>

@property(nonatomic,assign)BOOL showFunctionMenu;
@property(nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong)UIProgressView *loadingProgressView;

- (instancetype)initWithUrlString:(NSString *)urlString;
@end
