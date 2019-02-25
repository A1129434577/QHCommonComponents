//
//  DropDownViewController.m
//  moonbox
//
//  Created by 刘彬 on 2019/1/8.
//  Copyright © 2019 张琛. All rights reserved.
//

#import "LBItemsSelectViewController.h"

@interface LBItemsSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>
{
    UITableView *_tableView;
}
@end

@implementation LBItemsSelectViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        _popPC = self.popoverPresentationController;
        _popPC.delegate = self;
        
        _textAlignment = NSTextAlignmentCenter;
        _font = [UIFont systemFontOfSize:12];
    }
    return self;
}
-(UIModalPresentationStyle )adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;//不适配
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    [_tableView reloadData];
}

-(void)setItems:(NSArray<NSString *> *)items{
    _items = items;
    [_tableView reloadData];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DropDownViewCELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DROP_DOWN_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = _font;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < _items.count-1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, DropDownViewCELL_HEIGHT-0.5, CGRectGetWidth(tableView.frame)-15*2, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [cell addSubview:lineView];
    }
    cell.textLabel.text = _items[indexPath.row];
    cell.textLabel.textAlignment = _textAlignment;
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        WEAKSELF
        [self dismissViewControllerAnimated:YES completion:^{
            weakSelf.selectedItem?weakSelf.selectedItem(weakSelf.items[indexPath.row]):NULL;
        }];
    });
    
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
