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
        _font = font?font:[UIFont systemFontOfSize:16];
        
        //将分组Array变成一个Array
        if ([[array firstObject] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArray addObjectsFromArray:obj];
            }];
            array = tempArray;
        }
        
        //用_titleLabel去计算最长的title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = _font;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        __weak typeof(_titleLabel) weakTitleLabel = _titleLabel;
        NSArray *titleSortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            weakTitleLabel.text = obj1;
            CGSize labelSize1 = [weakTitleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            weakTitleLabel.text = obj2;
            CGSize labelSize2 = [weakTitleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            return labelSize1.width < labelSize2.width;
        }];
        
        _titleLabel.text = [titleSortedArray firstObject];
        _longestTitleWidth = [_titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))].width;
        
        _titleLabel.text = nil;
        _titleLabel.frame = CGRectMake(MAXFLOAT, MAXFLOAT, _longestTitleWidth, MAXFLOAT);
        
        _inputTextField = [[LBFunctionalTextField alloc] initWithFrame:CGRectMake(MAXFLOAT, MAXFLOAT, MAXFLOAT, MAXFLOAT)];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.textColor = [UIColor blackColor];
        _inputTextField.font = [UIFont systemFontOfSize:_font.pointSize-1];
        [self addSubview:_inputTextField];
    }
    
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)==MAXFLOAT?0:CGRectGetMinX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame)==MAXFLOAT?0:CGRectGetMinY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame)==MAXFLOAT?CGRectGetHeight(frame):CGRectGetHeight(_titleLabel.frame));
    _inputTextField.frame = CGRectMake(CGRectGetMinX(_inputTextField.frame)==MAXFLOAT?CGRectGetMaxX(_titleLabel.frame)+10:CGRectGetMinX(_inputTextField.frame), CGRectGetMinY(_inputTextField.frame)==MAXFLOAT?0:CGRectGetMinY(_inputTextField.frame), CGRectGetWidth(_inputTextField.frame)==MAXFLOAT?CGRectGetWidth(frame)-(CGRectGetMaxX(_titleLabel.frame)+10):CGRectGetWidth(_inputTextField.frame), CGRectGetHeight(_inputTextField.frame)==MAXFLOAT?CGRectGetHeight(frame):CGRectGetHeight(_inputTextField.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
