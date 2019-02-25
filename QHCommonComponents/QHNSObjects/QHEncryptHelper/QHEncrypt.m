//
//  Encrypt.m
//  SDK_AF_TEST
//
//  Created by 刘彬 on 16/5/24.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "QHEncrypt.h"
#import "LBSecKeyWrapper.h"

@implementation QHEncrypt

+(NSData *)encryptParameters:(id)parameters{
    
    NSString *parametersString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    //AES加密
    NSData *paramAesEncryptedData = [LBAESEncrypt AES128Encrypt:parametersString key:AES_KEY];
    
    //RSA加密
    NSData *publicKeyData = [[NSData alloc] initWithBase64EncodedString:PUBLIC_KEY options:NSDataBase64DecodingIgnoreUnknownCharacters];
     NSString *aesKeyHex = [self convertToHexStr:[AES_KEY dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *aesKeyData = [aesKeyHex dataUsingEncoding: NSUTF8StringEncoding];
    NSData *aesKeyEncryptedData= [LBSecKeyWrapper encrypt:aesKeyData publicKey:publicKeyData];
    
    NSMutableData *parametersEncryptedData = [aesKeyEncryptedData mutableCopy];
    [parametersEncryptedData appendData:paramAesEncryptedData];
    
    return [[self convertToHexStr:parametersEncryptedData] dataUsingEncoding:NSUTF8StringEncoding];
}
+(id )decryptionData:(NSData *)data{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *decryptedData = [LBAESEncrypt AES128Decrypt:[self hexStringToData:dataString] withKey:AES_KEY];
    return [NSJSONSerialization JSONObjectWithData:decryptedData options:kNilOptions error:nil];
}



//将NSData转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertToHexStr:(NSData *)data {
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+(NSData *)hexStringToData:(NSString *)hexString{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}
@end
