//
//  BLEManager.h
//
//  Created by lockezhang on 2018/12/18.
//  Copyright © 2018 lockezhang. All rights reserved.
//  蓝牙开锁器

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, QHLockerStatus) {
    QHLockerStatusOpened  = 0x55,//已开启
    QHLockerStatusLocked  = 0Xa0,//未开启
    QHLockerStatusUnusual = 0Xaa,//锁异常
};

@interface QHBLEManager : NSObject

@property (nonatomic, strong)CBPeripheral *cbPeripheral;// 当前连接设备
@property (nonatomic,strong)NSString *keyDeviceId;//从服务器取的开锁器id;
@property (nonatomic,copy)void(^receivedLockerNo)(NSString *lockerNo,QHLockerStatus status); // 返回锁(盒子)的number;
@property (nonatomic,copy)void(^battery)(NSInteger battery); // 获取电量信息

+(QHBLEManager *)share;
/** 根据蓝牙名连接蓝牙设备 */
-(void)connectPeripheralWithName:(NSString *)peripheralName success:(void (^)(void))success failure:(void (^)(NSString *errorMsg))failure;
/** 开锁 */
-(void)openLockSuccess:(void (^)(NSString *lockId))success failure:(void (^)(NSString *errorMsg))failure;
/** 断开开锁器连接 */
- (void)disConnectDeviceComplete:(void (^ _Nullable)(NSString *errorMsg))complete;

@end
