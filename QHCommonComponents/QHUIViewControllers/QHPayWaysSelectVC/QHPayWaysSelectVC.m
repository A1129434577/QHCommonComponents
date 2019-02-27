//
//  PayWaysViewController.m
//  moonbox
//
//  Created by 刘彬 on 2018/11/29.
//  Copyright © 2018 张琛. All rights reserved.
//

#import "QHPayWaysSelectVC.h"
#import "LBCustemPresentTransitions.h"
#import "UIImageView+WebCache.h"

#define PAY_WAYS_CELL_HEIGHT 60

@implementation QHPayWayObject
@end

@interface QHPayWaysSelectVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UINavigationController *_bankSourceNaVC;
    NSArray<id<PayWayObjectProtocol>> *_payWays;
    
    UIView *_lineView;
    UITableView *_payWaysTabView;
    UIView *_footerView;
}
@end

@implementation QHPayWaysSelectVC
- (instancetype)init
{
    return [[QHPayWaysSelectVC alloc] initWithPayWays:nil];
}
- (instancetype)initWithPayWays:(NSArray<id<PayWayObjectProtocol>> * _Nullable)payWays
{
    self = [super init];
    if (self) {
        LBCustemPresentTransitions *transitions = [LBCustemPresentTransitions shareInstanse];
        transitions.mbContentMode = MBViewContentModeCenter;
        _bankSourceNaVC = [[UINavigationController alloc] initWithRootViewController:self];
        _bankSourceNaVC.transitioningDelegate = transitions;
        _bankSourceNaVC.modalPresentationStyle = UIModalPresentationCustom;
        
        _payWays = payWays;
        
        
        _headerMessageLabel = [[UILabel alloc] init];
        _headerMessageLabel.numberOfLines = 0;
        _headerMessageLabel.font = [UIFont systemFontOfSize:25];
        _headerMessageLabel.textAlignment = NSTextAlignmentCenter;
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        
        _footerView = [[UIView alloc] init];
        _footerMessageLabel = [[UILabel alloc] init];
        _footerMessageLabel.numberOfLines = 0;
        _footerMessageLabel.font = [UIFont systemFontOfSize:14];
        _footerMessageLabel.textColor = [UIColor darkGrayColor];
        _footerMessageLabel.textAlignment = NSTextAlignmentCenter;
        
        _payWaysTabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payWaysTabView.backgroundColor = [UIColor clearColor];
        _payWaysTabView.dataSource = self;
        _payWaysTabView.delegate = self;
        _payWaysTabView.backgroundColor = [UIColor whiteColor];
        _payWaysTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    self.navigationController.view.layer.cornerRadius = 8;
    self.navigationController.view.clipsToBounds = YES;
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBarButton setImage:[UIImage imageNamed:@"close_2"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(qhPayCancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    self.view.frame = CGRectMake(0, 0, 250, 0);
    
    
    if (_headerMessage.length) {
        _headerMessageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [_headerMessageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame), CGFLOAT_MAX)].height+25*2);
        
        _lineView.frame = CGRectMake(0, CGRectGetHeight(_headerMessageLabel.frame)-0.5, CGRectGetWidth(_headerMessageLabel.frame), 0.5);
        [_headerMessageLabel addSubview:_lineView];
    }
    
    if (_footerMessage.length) {
        _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [_footerMessageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame)-20*2, CGFLOAT_MAX)].height+20);
        _footerMessageLabel.frame = CGRectMake(20, 0, CGRectGetWidth(_footerView.bounds)-20*2, CGRectGetHeight(_footerView.bounds));
        [_footerView addSubview:_footerMessageLabel];
    }
    
    
    _payWaysTabView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), PAY_WAYS_CELL_HEIGHT*_payWays.count+44+CGRectGetHeight(_headerMessageLabel.frame)+CGRectGetHeight(_footerMessageLabel.frame));
    _payWaysTabView.tableHeaderView = _headerMessageLabel;
    _payWaysTabView.tableFooterView = _footerView;
    [self.view addSubview:_payWaysTabView];

    
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(_payWaysTabView.frame));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setHeaderMessage:(NSString *)headerMessage{
    _headerMessage = headerMessage;
    _headerMessageLabel.text = headerMessage;
    [self loadView];
}

-(void)setFooterMessage:(NSString *)footerMessage{
    _footerMessage = footerMessage;
    _footerMessageLabel.text = footerMessage;
    [self loadView];
}

-(void)qhPayCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _payWays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PAY_WAYS_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PayWays_cell";
    QHPayWaysCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QHPayWaysCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:_payWays[indexPath.row].iconUrl]];
    cell.textLabel.text = _payWays[indexPath.row].payName;
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.payWaySelected?self.payWaySelected(_payWays[indexPath.row]):NULL;
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


@implementation QHPayWaysCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] init];//这里不用cell自带的imageView是因为重用的时候自带imageView会重绘
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.iconView.frame = CGRectMake(60 , (CGRectGetHeight(frame)-40)/2, 40, 40);
    self.separatorInset = UIEdgeInsetsMake(0, CGRectGetMaxX(self.iconView.frame)+20, 0, 0);
}

@end
