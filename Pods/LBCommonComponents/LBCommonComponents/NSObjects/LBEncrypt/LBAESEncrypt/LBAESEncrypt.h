//
//  AESEncrypt.h
//  SDK_AF_TEST
//
//  Created by 刘彬 on 16/5/26.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBAESEncrypt : NSObject
+(NSData *)AES128Encrypt:(NSString *)parametersString key:(NSString *)key;
+(NSData *)AES128Decrypt:(NSData *)data withKey:(NSString *)key;
@end
