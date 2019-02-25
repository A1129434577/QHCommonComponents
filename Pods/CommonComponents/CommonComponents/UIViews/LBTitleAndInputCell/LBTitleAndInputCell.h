//
//  TitleAndInputCell.h
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/11.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFunctionalTextField.h"

@interface LBTitleAndInputCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)LBFunctionalTextField *inputTextField;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier titleArray:(NSArray *)array font:(UIFont *)font;
@end
