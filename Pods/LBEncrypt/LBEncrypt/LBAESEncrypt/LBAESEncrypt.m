//
//  AESEncrypt.m
//  SDK_AF_TEST
//
//  Created by 刘彬 on 16/5/26.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBAESEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import <iconv.h>

@implementation LBAESEncrypt

+(NSString *)random128BitAESKey {
    unsigned char buf[32];
    arc4random_buf(buf, sizeof(buf));
    return [NSString stringWithFormat:@"%s",buf];
}



+(NSData *)AES128Encrypt:(NSString *)parametersString key:(NSString *)key//key为base64编码的
{
    NSData* data = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = (dataLength % kCCKeySizeAES128)?(kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128)):0;
    int newSize = (int)dataLength + diff;
    
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,kCCOptionECBMode,               //No padding
                                          [[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          kCCKeySizeAES256,
                                          NULL,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return resultData;
    }
    free(buffer);
    return nil;
}


+(NSData *)AES128Decrypt:(NSData *)data withKey:(NSString *)key//key为base64编码的
{
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,               //No padding,
                                          [[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          kCCKeySizeAES256,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        //因为解密后的数据里面在解密过程中加入了一些操作符，所以必须这样处理一次
        NSString *resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        resultString =[resultString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        //*******************************************************
        return [resultString dataUsingEncoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

@end
