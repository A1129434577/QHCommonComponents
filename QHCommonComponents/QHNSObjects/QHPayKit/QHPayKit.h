//
//  QHPayKit.h
//  QHCommonComponentsExample
//
//  Created by 刘彬 on 2019/2/26.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHPayKit : NSObject
+(void)weixinPayWithParameters:(NSDictionary *)parameters
                       success:(void (^)(NSDictionary *result))success
                       failure:(void (^)(NSString *errorMsg))failure;


+(void)alipayWithOrderStr:(NSString *)orderStr
                  success:(void (^)(NSDictionary *result))success
                  failure:(void (^)(NSString *errorMsg))failure;
@end

NS_ASSUME_NONNULL_END
