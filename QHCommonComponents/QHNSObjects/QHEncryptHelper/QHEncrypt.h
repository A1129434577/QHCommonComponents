//
//  Encrypt.h
//  SDK_AF_TEST
//
//  Created by 刘彬 on 16/5/24.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBAESEncrypt.h"

#define AES_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCB"

#define PUBLIC_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCstCODy0Px9bhF5Ro2WfX7zh+Kq76d19Bj/GHh1Lpdg3CrNjkQOyosqoadSEtpF2zL1VrVR3xFEFSI/jXZjCnDRZ4EuBS5WvJhWMmXyL9kcaG9q68XjcXg2UbMXVoUgqiTEKGPoYPjTB5lhua1dCkjakDzcCh7XaPbqOuWG5AmqwIDAQAB"

@interface QHEncrypt : NSObject
+(NSData *)encryptParameters:(id)parameters;
+(NSData *)decryptionData:(NSData *)data;
//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertToHexStr:(NSData *)data;
@end
