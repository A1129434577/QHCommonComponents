//
//  PayWaysViewController.m
//  moonbox
//
//  Created by 刘彬 on 2018/11/29.
//  Copyright © 2018 张琛. All rights reserved.
//

#import "QHPayWaysSelectVC.h"
#import "LBCustemPresentTransitions.h"
#import "QHPayWaysCell.h"
#import "UIImageView+WebCache.h"

@implementation QHPayWayObject
@end

@interface QHPayWaysSelectVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UINavigationController *_bankSourceNaVC;
    NSArray<id<PayWayObjectProtocol>> *_payWays;
    NSString *_subTitle;
    CGFloat _cellHeight;
}
@end

@implementation QHPayWaysSelectVC
- (instancetype)init
{
    return [[QHPayWaysSelectVC alloc] initWithPayWays:@[] title:@"" subTitle:@""];
}
- (instancetype)initWithPayWays:(NSArray<id<PayWayObjectProtocol>> *)payWays title:(NSString *)title subTitle:(NSString *_Nullable)subTitle
{
    self = [super init];
    if (self) {
        self.title = title;
        _subTitle = subTitle;
        
        LBCustemPresentTransitions *transitions = [LBCustemPresentTransitions shareInstanse];
        transitions.mbContentMode = MBViewContentModeCenter;
        _bankSourceNaVC = [[UINavigationController alloc] initWithRootViewController:self];
        _bankSourceNaVC.transitioningDelegate = transitions;
        _bankSourceNaVC.modalPresentationStyle = UIModalPresentationCustom;
        
        _payWays = payWays;
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    self.navigationController.view.layer.cornerRadius = 8;
    self.navigationController.view.clipsToBounds = YES;
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBarButton setImage:[UIImage imageNamed:@"close_2"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(receiveExpressPayCancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    self.view.frame = CGRectMake(0, 0, 250, 0);
    
    _cellHeight = 60;
    
    
    UILabel *tableHeaderView;
    if (_subTitle.length) {
        tableHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
        tableHeaderView.textAlignment = NSTextAlignmentCenter;
        tableHeaderView.font = [UIFont systemFontOfSize:25];
        if ([_subTitle containsString:@"盒子"]) {
            tableHeaderView.font = [UIFont systemFontOfSize:18];
        }
        tableHeaderView.text = _subTitle;
        tableHeaderView.numberOfLines = 0;
        tableHeaderView.adjustsFontSizeToFitWidth = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(tableHeaderView.frame)-0.5, CGRectGetWidth(tableHeaderView.frame), 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [tableHeaderView addSubview:lineView];
    }
    
    if (_cellHeight*_payWays.count+CGRectGetHeight(tableHeaderView.frame)<100) {
        _cellHeight = 100;
    }
    
    
    
    UITableView *payWaysTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), _cellHeight*_payWays.count+44+CGRectGetHeight(tableHeaderView.frame)) style:UITableViewStylePlain];
    payWaysTabView.backgroundColor = [UIColor clearColor];
    payWaysTabView.dataSource = self;
    payWaysTabView.delegate = self;
    payWaysTabView.backgroundColor = [UIColor whiteColor];
    payWaysTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:payWaysTabView];
    payWaysTabView.tableHeaderView = tableHeaderView;
    
    
    
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(payWaysTabView.frame));
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)receiveExpressPayCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _payWays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
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
