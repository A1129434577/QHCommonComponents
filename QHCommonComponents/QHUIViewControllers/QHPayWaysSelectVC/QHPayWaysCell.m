//
//  PayWayTableViewCell.m
//  moonbox
//
//  Created by 刘彬 on 2018/12/12.
//  Copyright © 2018 张琛. All rights reserved.
//

#import "QHPayWaysCell.h"

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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.iconView.frame = CGRectMake(60 , (CGRectGetHeight(frame)-40)/2, 40, 40);
    self.separatorInset = UIEdgeInsetsMake(0, CGRectGetMaxX(self.iconView.frame)+20, 0, 0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
