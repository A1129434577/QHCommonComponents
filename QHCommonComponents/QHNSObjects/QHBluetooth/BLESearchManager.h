//
//  BLESearchManager.h
//  moonbox
//
//  Created by 张琛 on 2018/12/18.
//  Copyright © 2018年 张琛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHBLESearchManager : NSObject
@property (nonatomic, copy)void (^didFindPeripheral)(NSMutableArray<CBPeripheral *> *peripherals,CBPeripheral *peripheral);//搜索到开锁器;
/// 中央管理者
@property (nonatomic, strong) CBCentralManager *centralManager;

+(QHBLESearchManager *)share;
/** 搜索附近开锁器 */
- (void)searchNearbyDevices:(void (^ _Nullable)(NSMutableArray<CBPeripheral *> *peripherals,CBPeripheral *peripheral))success
                    failure:(void (^ _Nullable)(NSString *errorMsg))failure;


@end

NS_ASSUME_NONNULL_END
