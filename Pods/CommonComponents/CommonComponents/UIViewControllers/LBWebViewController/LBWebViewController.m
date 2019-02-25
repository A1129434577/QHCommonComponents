//
//  AuthsManageViewController.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/13.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBWebViewController.h"

@interface LBWebViewController ()
@property(nonatomic,strong)NSString *urlString;
@property (nonatomic, strong)UIProgressView *loadingProgressView;

@end

@implementation LBWebViewController
- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
        
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    _loadingProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    _loadingProgressView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 8);
    _loadingProgressView.progressTintColor = [UIColor greenColor];
    _loadingProgressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_loadingProgressView];
    
    CATextLayer *hostLPromptLayer = [[CATextLayer alloc] init];
    hostLPromptLayer.frame = CGRectMake(0, 10, CGRectGetWidth(_webView.bounds), 20);
    hostLPromptLayer.wrapped = YES;
    hostLPromptLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    hostLPromptLayer.font = fontRef;
    hostLPromptLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    hostLPromptLayer.foregroundColor = [UIColor grayColor].CGColor;
    hostLPromptLayer.alignmentMode = kCAAlignmentCenter;
    [_webView.layer insertSublayer:hostLPromptLayer atIndex:0];
    
    
    if (_showFunctionMenu) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        backBtn.contentMode = UIViewContentModeScaleAspectFit;
        [backBtn setImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self
                    action:@selector(goBack:)
          forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *forwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [forwardBtn setImage:[UIImage imageNamed:@"ic_forward.png"] forState:UIControlStateNormal];
        forwardBtn.backgroundColor = [UIColor clearColor];
        [forwardBtn addTarget:self
                       action:@selector(goForward:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithCustomView:forwardBtn];
        self.navigationItem.rightBarButtonItems = @[refreshItem,forwardItem,backItem];
    }
    
    [_webView loadRequest:request];
    
}



- (void)goBack:(UIButton*)sender
{
    if ([_webView canGoBack]) {
        [_webView goBack];
        
    }
}
-(void)goForward:(UIButton *)sender{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}
- (void)refresh:(UIButton*)sender
{
    [_webView reload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"estimatedProgress"]) {
        [_loadingProgressView setProgress:_webView.estimatedProgress animated:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//页面开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    _loadingProgressView.hidden = NO;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _loadingProgressView.hidden = YES;
    if (!self.title.length) {
        self.title = webView.title;
    }
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    _loadingProgressView.hidden = YES;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (_showFunctionMenu) {
        CATextLayer *hostLPromptLayer = (CATextLayer *)[webView.layer.sublayers firstObject];
        hostLPromptLayer.string = [NSString stringWithFormat:@"网页由 %@ 提供",navigationAction.request.URL.host];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



-(UIImage *)changeImage:(UIImage *)image toColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
