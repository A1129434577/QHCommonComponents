//
//  NSString+LBToDate.m
//  CommonComponentsTestProject
//
//  Created by 刘彬 on 2019/3/5.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "NSString+LBToDate.h"

@implementation NSString (LBToDate)
- (NSDate *)convertToDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}
@end
