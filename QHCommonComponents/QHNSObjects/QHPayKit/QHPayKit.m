//
//  QHPayKit.m
//  QHCommonComponentsExample
//
//  Created by 刘彬 on 2019/2/26.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "QHPayKit.h"
#import "XHPayKit.h"

@implementation QHPayKit
+(void)weixinPayWithParameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *result))success
                       failure:(void (^)(NSString *errorMsg))failure{
    if (![XHPayKit isWxAppInstalled]) {
        failure(@"无法打开微信");
        return;
    }
    
    XHPayWxReq *wxReq = [[XHPayWxReq alloc] init];
    wxReq.openID = parameters[@"appid"];
    wxReq.partnerId = parameters[@"partnerid"];
    wxReq.prepayId = parameters[@"prepayid"];
    wxReq.nonceStr = parameters[@"noncestr"];
    wxReq.timeStamp = [parameters[@"timestamp"] intValue];
    wxReq.package = parameters[@"package"];
    wxReq.sign = parameters[@"sign"];
    
    
    
    [[XHPayKit defaultManager] wxpayOrder:wxReq completed:^(NSDictionary *resultDict) {
        
        
        if ([resultDict[@"errCode"] integerValue] == 0) {
            NSMutableDictionary *successResult = [NSMutableDictionary dictionary];
            [successResult setObject:@"微信支付成功" forKey:@"payResultMsg"];
            [successResult setObject:@(1) forKey:@"payResultCode"];
            [successResult setObject:wxReq.sign forKey:@"resultInfo"];
            success(successResult);
        }else{
            failure(resultDict[@"errStr"]);
        }
    }];
}


+(void)alipayWithOrderStr:(NSString *)orderStr
                  success:(void (^)(NSDictionary *result))success
                  failure:(void (^)(NSString *errorMsg))failure{
    if (![XHPayKit isAliAppInstalled]) {
        failure(@"无法打开支付宝");
        return ;
    }
    [[XHPayKit defaultManager] alipayOrder:orderStr fromScheme:BUNDLE_IDENTIFIER completed:^(NSDictionary *resultDict) {
        if ([resultDict[@"resultStatus"] integerValue] == 9000) {
            
            NSMutableDictionary *successResult = [NSMutableDictionary dictionary];
            [successResult setObject:@"支付宝支付成功" forKey:@"payResultMsg"];
            [successResult setObject:@(1) forKey:@"payResultCode"];
            [successResult setObject:[[resultDict[@"result"] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] forKey:@"resultInfo"];
            success(successResult);
        }else{
            failure(resultDict[@"memo"]);
        }
    }];
}
@end
