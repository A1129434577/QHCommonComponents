//
//  TitleAndInputCell.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/11.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBTitleAndInputCell.h"
@interface LBTitleAndInputCell()
@property (nonatomic,assign)CGFloat longestTitleWidth;
@property (nonatomic,assign)UIFont *font;
@end
@implementation LBTitleAndInputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier titleArray:(NSArray *)array font:(UIFont *)font{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _font = font?font:[UIFont systemFontOfSize:16];
        
        if ([[array firstObject] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArray addObjectsFromArray:obj];
            }];
            array = tempArray;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.font = _font;
        label.numberOfLines = 0;
        
        NSArray *titleSortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            label.text = obj1;
            CGSize labelSize1 = [label sizeThatFits:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
            label.text = obj2;
            CGSize labelSize2 = [label sizeThatFits:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
            return labelSize1.width < labelSize2.width;
        }];
        
        label.text = [titleSortedArray firstObject];
        _longestTitleWidth = [label sizeThatFits:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44)].width;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = font;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _inputTextField = [[LBFunctionalTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
        _inputTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputTextField.layer.cornerRadius = 10;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.font = [UIFont systemFontOfSize:font.pointSize-1];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:_inputTextField];
        
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, CGRectGetHeight(_inputTextField.frame))];
        _inputTextField.leftView = leftView;
    }
    
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _titleLabel.frame = CGRectMake(15, 0, _longestTitleWidth, CGRectGetHeight(frame));
    _inputTextField.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, (CGRectGetHeight(frame)-CGRectGetHeight(_inputTextField.frame))/2, CGRectGetWidth(frame)-(CGRectGetMaxX(_titleLabel.frame)+10)-15, 35);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
