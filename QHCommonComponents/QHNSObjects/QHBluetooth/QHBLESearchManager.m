//
//  BLESearchManager.m
//  moonbox
//
//  Created by 张琛 on 2018/12/18.
//  Copyright © 2018年 张琛. All rights reserved.
//

#import "QHBLESearchManager.h"
@interface QHBLESearchManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,strong)dispatch_source_t connectTimeoutTimer;
@property (nonatomic, copy ,nullable)void (^searchPeripheralFaild)(NSString * _Nullable errorMsg);//开锁设备搜索失败block


@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;//搜索到的设备列表
@end

@implementation QHBLESearchManager



+(QHBLESearchManager *)share {
    static QHBLESearchManager *bluetooth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bluetooth = [[QHBLESearchManager alloc] init];
        bluetooth.peripherals = [NSMutableArray array];
    });
    return bluetooth;
}

/** 搜索附近开锁器 */
- (void)searchNearbyDevices:(void (^ _Nullable)(NSMutableArray<CBPeripheral *> *peripherals,CBPeripheral *peripheral))success
                    failure:(void (^ _Nullable)(NSString *errorMsg))failure {
    _didFindPeripheral = success;
    _searchPeripheralFaild = failure;
    [_peripherals removeAllObjects];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}
/**
 *  --  初始化成功自动调用
 *  --  必须实现的代理，用来返回创建的centralManager的状态。
 *  --  注意：必须确认当前是CBCentralManagerStatePoweredOn状态才可以调用扫描外设的方法：
 scanForPeripheralsWithServices
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:
        case CBManagerStateResetting:
        case CBManagerStateUnsupported:
        case CBManagerStateUnauthorized:
        case CBManagerStatePoweredOff:
            _searchPeripheralFaild?_searchPeripheralFaild(@"蓝牙初始化失败，请检查蓝牙是否打开"):NULL;
            break;
        case CBManagerStatePoweredOn:
        {
            // 开始扫描周围的外设。
            /*
             -- 两个参数为Nil表示默认扫描所有可见蓝牙设备。
             -- 注意：第一个参数是用来扫描有指定服务的外设。然后有些外设的服务是相同的，比如都有FFF5服务，那么都会发现；而有些外设的服务是不可见的，就会扫描不到设备。
             -- 成功扫描到外设后调用didDiscoverPeripheral
             */
            [self.centralManager scanForPeripheralsWithServices:nil  options:nil];
            
            //搜索蓝牙设备超时时间为8秒，超过8秒搜索失败
            __block int count = 0;
            NSTimeInterval period = 1.0; //设置时间间隔
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _connectTimeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_connectTimeoutTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
            __weak typeof(self) weakSelf = self;
            dispatch_source_set_event_handler(_connectTimeoutTimer, ^{
                count ++;
                if (count == 8) {
                    dispatch_cancel(weakSelf.connectTimeoutTimer);
                    
                    if (!self.peripherals.count) {
                        [self.centralManager stopScan];//停止扫描
                        weakSelf.searchPeripheralFaild?weakSelf.searchPeripheralFaild(@"未搜索到设备，请确保设备是否开启"):NULL;
                    }
                }
            });
            dispatch_resume(_connectTimeoutTimer);
            break;
        }
        default:
            break;
    }
}

/**
 扫描到设备
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name containsString:@"QHIOT"]) {
        if (![_peripherals containsObject:peripheral]) {
            [_peripherals addObject:peripheral];
            _didFindPeripheral?_didFindPeripheral(_peripherals,peripheral):NULL;
        }
    }
}


@end
