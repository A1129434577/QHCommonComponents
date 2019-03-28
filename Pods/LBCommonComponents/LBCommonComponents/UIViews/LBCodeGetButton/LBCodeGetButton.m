//
//  GetCodeButton.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/4/11.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBCodeGetButton.h"

@interface LBCodeGetButton()
@property (nonatomic,copy)void (^action)(LBCodeGetButton *sender);
@property (nonatomic,assign)UIBackgroundTaskIdentifier taskIdentifier;
@end
@implementation LBCodeGetButton

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(LBCodeGetButton *sender))action
{
    self = [super initWithFrame:frame];
    if (self) {
        _action = action;
        self.waiting = NO;
        
        self.layer.cornerRadius = 5;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addTarget:self action:@selector(getCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)getCodeButtonAction{
    __weak typeof(self) weakSelf = self;
    _action?_action(weakSelf):NULL;
}

-(void)setWaiting:(BOOL)waiting{
    _waiting = waiting;
    if (waiting) {
        self.enabled = NO;
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self setTitle:@"60s" forState:UIControlStateNormal];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wait:) userInfo:self repeats:YES];
        _taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }else{
        self.enabled = YES;
        self.backgroundColor = UIColorRGBHex(0x10c6bf);
        [self setTitle:@"验证码" forState:UIControlStateNormal];
        [[UIApplication sharedApplication] endBackgroundTask:_taskIdentifier];
    }
}

-(void)wait:(NSTimer *)timer{
    NSInteger seconds = [[self titleForState:UIControlStateNormal] integerValue];
    seconds --;
    [self setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    if (seconds == 0) {
        self.waiting = NO;
        [timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
