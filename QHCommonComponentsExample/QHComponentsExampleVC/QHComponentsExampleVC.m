//
//  ViewController.m
//  QHCommonComponentsExample
//
//  Created by 刘彬 on 2019/2/25.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "QHComponentsExampleVC.h"
#import "QHAlertController.h"

@interface QHComponentsExampleVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_testTitleArray;
}
@end

@implementation QHComponentsExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _testTitleArray = @[@"QHAlertController TEST"].mutableCopy;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _testTitleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TEST_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _testTitleArray[indexPath.row];
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *testTitle = _testTitleArray[indexPath.row];
    if ([testTitle containsString:@"QHAlertController"]){
        QHAlertController *qhAlertC = [[QHAlertController alloc] initWithAlertTitle:@"提示" message:@"巧盒物联弹窗测试"];
        [self presentViewController:qhAlertC animated:YES completion:NULL];
        [qhAlertC addActionTitle:@"确定" action:^(UIButton *sender, NSDictionary *userInfo) {
            ;
        }];
        [qhAlertC addActionTitle:@"取消" action:^(UIButton *sender, NSDictionary *userInfo) {
            ;
        }];
    }
}
@end

