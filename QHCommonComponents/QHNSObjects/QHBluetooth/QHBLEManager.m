//
//  BLEManager.h
//
//  Created by lockezhang on 2018/12/18.
//  Copyright © 2018 lockezhang. All rights reserved.
//

#import "QHBLEManager.h"
#import "AMRPlayerTool.h"

//心跳服务和特征
NSString *const HeartServiceUUID = @"99F788A8-F20A-4EFE-84F9-06D28484E41A";
NSString *const HeartCharacteristicsUUID = @"7d4f14e6-329f-4cc2-be6a-9195d55aa978";

//密钥服务和特征
NSString *const KeyServiceUUID = @"C7DD20A0-2CB0-4A4A-8E29-F14F427C1D97";
NSString *const KeyCharacteristicsUUID = @"ce7b2a53-1dc4-4a7a-ba60-0f7489b5c859";

//主动上报设备信息给APP的服务和特征
NSString *const ReportServiceUUID = @"30918EEA-D5F7-4FF7-A9FD-FB0DEBD21993";
NSString *const ReportCharacteristicsUUID = @"cbabe86a-ae10-41ce-852f-4ef1993d8dd8";

//开锁服务和特征
NSString *const UnlockingServiceUUID = @"FD7550BD-F43D-43C3-866B-1F39507A7FD3";
NSString *const UnlockingCharacteristicsUUID = @"39a36eb2-ca06-4163-b49a-76e64ec79a93";

//电量服务和特征
NSString *const BatteryServiceUUID = @"180F";
NSString *const BatteryCharacteristicsUUID = @"2a19";

//软硬件版本服务
NSString *const VersionServiceUUID = @"180A";
//软件版本特征
NSString *const SoftwareVersionCharacteristicsUUID = @"2a28";


@interface QHBLEManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    int _currentScanIndex;
    dispatch_source_t _heartTimer;
    dispatch_source_t _batteryTimer;
    
}
@property (nonatomic, strong)dispatch_source_t connectTimeoutTimer;
@property (nonatomic, strong)NSString *peripheralName;//蓝牙锁设备名
@property (nonatomic, strong)NSArray *serviceUUIDArray;//蓝牙设备服务ids

@property (nonatomic, strong)NSData *publicKeyData;//蓝牙锁公钥
@property (nonatomic, assign)int privateKey;//蓝牙锁私钥

@property (nonatomic, strong)NSString *lockNo;//锁（盒子）设备No
@property (nonatomic, strong)NSData *lockNoDate;//锁（盒子）设备NoData
@property (nonatomic, strong)NSString *softwareVersion;//开锁器软件版本

@property (nonatomic, copy)void (^openLockSuccess)(NSString *lockId);//开锁成功block
@property (nonatomic, copy)void (^openLockFailed)(NSString *lockId,NSString *errorMsg);//开锁成功block

/// 中央管理者 -->管理设备的扫描 --连接
@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic,strong)CBCharacteristic *heardCharacteristic; // 心跳特征
@property (nonatomic,strong)CBCharacteristic *keyCharacteristic;//密钥特征
@property (nonatomic,strong)CBCharacteristic *reportCharacteristic; //上报特征
@property (nonatomic,strong)CBCharacteristic *unlockCharacteristic; // 开锁特征
@property (nonatomic,strong)CBCharacteristic *batteryCharacteristic;//电量特征
@end
@implementation QHBLEManager

+(QHBLEManager *)share{
    static QHBLEManager *bluetooth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bluetooth = [[QHBLEManager alloc] init];
        
        //服务列表（会根据服务列表去依次查询特征列表，依次查询完成之后才标注蓝牙连接成功）
        bluetooth.serviceUUIDArray = @[
                                       [CBUUID UUIDWithString:VersionServiceUUID],
                                       [CBUUID UUIDWithString:HeartServiceUUID],
                                       [CBUUID UUIDWithString:KeyServiceUUID],
                                       [CBUUID UUIDWithString:ReportServiceUUID],
                                       [CBUUID UUIDWithString:UnlockingServiceUUID],
                                       [CBUUID UUIDWithString:BatteryServiceUUID]];
        
        //初始化公钥
        Byte byte[] = {0x04,0x02,0x05,0x09};
        bluetooth.publicKeyData = [NSData dataWithBytes:byte length:sizeof(byte)];
    });
    return bluetooth;
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
            [[AMRPlayerTool share] playAudioWithName:@"disconnect" type:@"mp3"];
            _peripheralDisconnected?_peripheralDisconnected(@"蓝牙初始化失败，请检查是否打开蓝牙"):NULL;
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
            
            //搜索蓝牙设备超时时间为6秒，超过6秒搜索链接失败
            __block int count = 0;
            NSTimeInterval period = 1.0; //设置时间间隔
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _connectTimeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_connectTimeoutTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
            __weak typeof(self) weakSelf = self;
            dispatch_source_set_event_handler(_connectTimeoutTimer, ^{
                count ++;
                if (count == 6) {
                    dispatch_cancel(weakSelf.connectTimeoutTimer);
                    
                    if (!self.cbPeripheral) {
                        [self.centralManager stopScan];//停止扫描
                        weakSelf.peripheralDisconnected?weakSelf.peripheralDisconnected(@"未搜索到设备，请确保设备是否开启"):NULL;
                    }
                }
            });
            dispatch_resume(_connectTimeoutTimer);
            
        }
            break;
        default:
            break;
    }
    
}


-(void)connectPeripheralWithName:(NSString *)peripheralName success:(void (^)(void))success failure:(void (^)(NSString * _Nullable))failure{
    
    //如果蓝牙名没变且是链接状态，直接标记已连接
    if ([peripheralName isEqualToString:_peripheralName] && (_cbPeripheral.state == CBPeripheralStateConnected)) {
        success();
    }else{
        if (_cbPeripheral) {
            //当前链接了一个蓝牙需要取消其连接并清空私钥以保证能获取新的私钥
            [_centralManager cancelPeripheralConnection:_cbPeripheral];
            _privateKey = 0;
        }
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        
        _peripheralName = peripheralName;
        _peripheralConnected = success;
        _peripheralDisconnected = failure;
    }
}
/** 断开开锁器连接 */
- (void)disConnectDeviceComplete:(void (^)(NSString * _Nullable))complete{
    if (self.cbPeripheral) {
        [_centralManager cancelPeripheralConnection:self.cbPeripheral];
    }
    _privateKey = 0;
    if (complete) {
        _peripheralDisconnected = complete;
    }
    
}

#pragma mark - private
/**
 扫描到设备
 
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name containsString:_peripheralName]) {
        self.cbPeripheral = peripheral;
        [self.centralManager stopScan];//停止扫描
        //开始链接设备
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连接成功
 
 @param central 中心管理者
 @param peripheral 连接成功的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    // 设置设备的代理
    self.cbPeripheral.delegate = self;
    
    _currentScanIndex = 0;
    // services:传入nil  代表扫描所有服务
    //开始扫描服务
    [self.cbPeripheral discoverServices:@[_serviceUUIDArray[_currentScanIndex]]];
}

/**
 连接失败
 
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if ([peripheral.name isEqualToString:_peripheralName]) {
        [[AMRPlayerTool share] playAudioWithName:@"disconnect" type:@"mp3"];
        _peripheralDisconnected?_peripheralDisconnected(@"开锁器连接失败"):NULL;
    }
}

/**
 连接断开

 @param central 中心管理者
 @param peripheral 连接断开的设备
 @param error 错误信息
 */

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if ([peripheral.name isEqualToString:_peripheralName]) {
        _peripheralDisconnected?_peripheralDisconnected(@"开锁器连接断开"):NULL;
    }
}


/**
 扫描到服务
 
 @param peripheral 服务对应的设备
 @param error 扫描错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        [[AMRPlayerTool share] playAudioWithName:@"disconnect" type:@"mp3"];
        _peripheralDisconnected?_peripheralDisconnected(error.localizedDescription):NULL;
    }else{
        if (_currentScanIndex < self.cbPeripheral.services.count) {
            // 根据服务去扫描特征
            [self.cbPeripheral discoverCharacteristics:nil forService:self.cbPeripheral.services[_currentScanIndex]];//每扫描到一个服务后服务列表数据会新增上这个服务
        }
    }
}


/**
 扫描到对应的特征
 
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        [[AMRPlayerTool share] playAudioWithName:@"disconnect" type:@"mp3"];
        _peripheralDisconnected?_peripheralDisconnected(error.localizedDescription):NULL;
    }else{
        NSString *serviceUUIDString = service.UUID.UUIDString.uppercaseString;
        
        if ([serviceUUIDString isEqualToString:VersionServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                if ([characteristicsUUIDString isEqualToString:SoftwareVersionCharacteristicsUUID]){
                    [self.cbPeripheral readValueForCharacteristic:characteristic];
                    break;
                }
            }
        }
        else if ([serviceUUIDString isEqualToString:HeartServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                
                //链接成功发送心跳包保持链接
                if ([characteristicsUUIDString isEqualToString:HeartCharacteristicsUUID]) {
                    
                    _heardCharacteristic = characteristic;
                    
                    NSTimeInterval period = 4.0; //设置时间间隔
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _heartTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_heartTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
                    __weak typeof(self) weakSelf = self;
                    dispatch_source_set_event_handler(_heartTimer, ^{
                        Byte byte[] = {0xAA};
                        [self.cbPeripheral writeValue:[NSData dataWithBytes:byte length:sizeof(byte)] forCharacteristic:weakSelf.heardCharacteristic type:CBCharacteristicWriteWithResponse];
                        
                    });
                    dispatch_resume(_heartTimer);
                    
                    break;
                }
            }
            
        }else if ([serviceUUIDString isEqualToString:KeyServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                if ([characteristicsUUIDString isEqualToString:KeyCharacteristicsUUID]){
                    
                    _keyCharacteristic = characteristic;
                    if (!_privateKey) {
                        [self.cbPeripheral setNotifyValue:YES forCharacteristic:characteristic];// 设置监听
                        [self.cbPeripheral writeValue:_publicKeyData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    }
                    break;
                }
            }
            
        }else if ([serviceUUIDString isEqualToString:ReportServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                if ([characteristicsUUIDString isEqualToString:ReportCharacteristicsUUID]){
                    
                    _reportCharacteristic = characteristic;
                    [self.cbPeripheral setNotifyValue:YES forCharacteristic:characteristic]; // 设置监听
                    break;
                    
                }
            }
            
        }else if ([serviceUUIDString isEqualToString:UnlockingServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                if ([characteristicsUUIDString isEqualToString:UnlockingCharacteristicsUUID]){
                    
                    _unlockCharacteristic = characteristic;
                    [self.cbPeripheral setNotifyValue:YES forCharacteristic:characteristic]; // 设置监听
                    break;
                    
                }
            }
            
        }else if ([serviceUUIDString isEqualToString:BatteryServiceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
                if ([characteristicsUUIDString isEqualToString:BatteryCharacteristicsUUID]){
                    _batteryCharacteristic = characteristic;
                    [self startGetBattery];
                    break;
                }
            }
            
        }
        
        
        //其他逻辑
        if (_currentScanIndex < _serviceUUIDArray.count-1) {//因为这里进行先加后再加入运算所以要-1
            _currentScanIndex ++;
            //services:传入nil  代表扫描所有服务
            //依次去扫描第二个服务和其包含的特征
            [self.cbPeripheral discoverServices:@[_serviceUUIDArray[_currentScanIndex]]];
        }else if (_currentScanIndex == _serviceUUIDArray.count-1){
            //当所有需要用到的服务和特征都扫描成功后表示连接成功
            _currentScanIndex ++;
            _peripheralConnected?_peripheralConnected():NULL;
            [[AMRPlayerTool share] playAudioWithName:@"connect" type:@"mp3"];
        }
    }
    
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    NSString *characteristicsUUIDString = characteristic.UUID.UUIDString.lowercaseString;
    
    NSData *receiveDecryptedDate = [self decrypt:characteristic.value];
    
    if ([characteristicsUUIDString isEqualToString:SoftwareVersionCharacteristicsUUID]){
        _softwareVersion = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    }
    else if (characteristic == _keyCharacteristic){
        // 用公钥与锁返回的私钥进行如下异或操作，产生新的APP端用的私钥
        Byte *publickey = (Byte *)[_publicKeyData bytes];
        Byte *key = (Byte *)[characteristic.value bytes];
        NSString *versionString = _softwareVersion;
        if ([versionString containsString:@"V"] || [versionString containsString:@"v"]) {
            versionString = [versionString substringFromIndex:1];
        }
        if (versionString.integerValue < 3) {
            int a = (int)(publickey[0] ^ key[3]);
            int b = (int)(publickey[3] ^ key[2]);
            int c = (int)(publickey[2] ^ key[0]);
            int d = (int)(publickey[1] ^ key[1]);
            self.privateKey = (a + b) ^ (c + d);
        }else{//开锁器软件版本大于等于V3.0的时候用一下算法
            int a = (int)(publickey[1] ^ key[3]);
            int b = (int)(publickey[3] ^ key[2]);
            int c = (int)(publickey[2] ^ key[1]);
            int d = (int)(publickey[0] ^ key[0]);
            self.privateKey = (a + b) ^ (c + d);
        }
    }
    else if (characteristic == _reportCharacteristic){
        //获取到箱锁设备信息
        Byte *bytes = (Byte *)[receiveDecryptedDate bytes];
        int length = @([receiveDecryptedDate length]).intValue;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i=3; i<length; i++) {
            if (i > 2 && i < 10) {
                int c = (int)bytes[i];
                [arr addObject:[self ToHex:c]];
            }
        }
        
        _lockNo = [arr componentsJoinedByString:@""];
        if (_lockNo.length) {
            _lockNoDate = receiveDecryptedDate;
            [self sendAck:_lockNoDate];//接收到设备信息之后通知开锁器停止上报
            
            //获取锁状态
            Byte byte = 0x00;
            if (length ==13) {
                byte = bytes[10];
            }
            
            QHLockerStatus lockerStatus = byte;
            __weak typeof(_lockNo) weakLockNo = _lockNo;
            _receivedLockerNo?_receivedLockerNo(weakLockNo,lockerStatus):NULL;
        }
        
    }
    else if (characteristic == _unlockCharacteristic){//成功接收到开锁成功信息后标记开锁成功
        Byte *bytes = (Byte *)[receiveDecryptedDate bytes];
        int length = @([receiveDecryptedDate length]).intValue;
        Byte byte = 0x00;
        if (length ==13) {
            byte = bytes[10];
        }
        
        __weak typeof(_lockNo) weakLockNo = _lockNo;
        switch (byte) {
            case 0x55://开锁成功
                [[AMRPlayerTool share] playAudioWithName:@"open_success" type:@"mp3"];
                _openLockSuccess?_openLockSuccess(weakLockNo):NULL;
                break;
            case 0Xa0://开锁失败
            case 0Xaa://快递锁无响应
                [[AMRPlayerTool share] playAudioWithName:@"open_fail" type:@"mp3"];
                _openLockFailed?_openLockFailed(weakLockNo,@"开锁失败"):NULL;
                break;
            default:
                break;
        }
        
        
    }
    else if (characteristic == _batteryCharacteristic){//获取电量信息
        Byte *bytes = (Byte *)[characteristic.value bytes];
        NSInteger battery = @((int)bytes[0]).integerValue;
        _battery?_battery(battery):NULL;
    }
}

// 获取开锁器电量
- (void)startGetBattery {
    NSTimeInterval period = 10.; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _batteryTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_batteryTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_batteryTimer, ^{
        [self.cbPeripheral readValueForCharacteristic:self.batteryCharacteristic];
    });
    dispatch_resume(_batteryTimer);
}

//将十进制转化为十六进制
- (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    //不够一个字节凑0
    if(str.length == 1){
        return [NSString stringWithFormat:@"0%@",str];
    }else{
        return str;
    }
}
// 加密
- (NSData *)encrypt:(NSData *)data {
    int length = @([data length]).intValue;
    Byte *retByte = malloc(sizeof(Byte)*(length));
    Byte *bytes = (Byte *)[data bytes];
    for (NSInteger i = 0; i < length; i++) {
        int d = bytes[i] ^ self.privateKey;
        retByte[i] = d;
    }
    NSData *retData = [NSData dataWithBytes:retByte length:length];
    return retData;
}

// 解密
- (NSData *)decrypt:(NSData *)data {
    int length = @([data length]).intValue;
    Byte *retByte = malloc(sizeof(Byte)*(length));
    Byte *bytes = (Byte *)[data bytes];
    for (NSInteger i = 0; i < length; i++) {
        int d = self.privateKey ^ bytes[i];
        retByte[i] = d;
    }
    NSData *retData = [NSData dataWithBytes:retByte length:length];
    return retData;
}

- (void)openLockSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSString * _Nullable, NSString * _Nullable))failure{
    if (!_lockNoDate) {
        failure(nil,@"请用开锁器接触盒子锁");
        return;
    }
    _openLockSuccess = success;
    _openLockFailed = failure;
    
    /** 发起开锁命令 */
        int length = 13;
        Byte *retByte = malloc(sizeof(Byte)*(length));
        retByte[0] = 0x2A;
        retByte[1] = 0x08;
        retByte[2] = 0x03; // 命令
    Byte *bytes = (Byte *)[_lockNoDate bytes];
        int j = 0;
        // 校验位累加开始
        int vilidate = (int)0x03;
        // 加入数据位，包含盒子ID，数据控制位
        for (int i = 3; i < length; i++) {
            if (i > 2 && i < 10) {
                retByte[i] = bytes[i];
                vilidate += (int)retByte[i];
                j = i + 1;
            }
        }
        // 数据控制位，这里的0xAA代表“开锁”（来自硬件文档）
        retByte[j] = 0xAA;
        // 校验位累加的最终值
        vilidate += (int)retByte[j];
        // 取最低的一个字节放入数据位的控制位中
        Byte vilidateByte = (Byte)vilidate;
        j++;
        retByte[j] = vilidateByte;
        
        // 加入固定值
        j++;
        retByte[j] = 0x23;
        // 包装加密数据包
        NSData *sendData = [NSData dataWithBytes:retByte length:length];
        sendData = [self encrypt:sendData];
        // 向蓝牙写入命令数据
        [self.cbPeripheral writeValue:sendData forCharacteristic:_unlockCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)setBattery:(void (^)(NSInteger))battery{
    _battery = battery;
    [self.cbPeripheral readValueForCharacteristic:_batteryCharacteristic];
}

/** Ack回复 */
- (void)sendAck:(NSData *)data {
    int length = @([data length]).intValue;
    Byte *retByte = malloc(sizeof(Byte)*(length));
    retByte[0] = 0x2A;
    retByte[1] = 0x08;
    retByte[2] = 0x08; // 命令
    Byte *bytes = (Byte *)[data bytes];
    int j = 0;
    // 校验位累加开始
    int vilidate = (int)0x08;
    // 加入数据位，包含盒子ID，数据控制位
    for (int i = 3; i < length; i++) {
        if (i > 2 && i < 10) {
            retByte[i] = bytes[i];
            vilidate += (int)retByte[i];
            j = i + 1;
        }
    }
    // 数据控制位，这里的0xAA代表"已收到"（来自硬件文档）
    retByte[j] = 0x01;
    // 校验位累加的最终值
    vilidate += (int)retByte[j];
    // 取最低的一个字节放入数据位的控制位中
    Byte vilidateByte = (Byte)vilidate;
    j++;
    retByte[j] = vilidateByte;
    
    // 加入固定值
    j++;
    retByte[j] = 0x23;
    // 包装加密数据包
    NSData *sendData = [NSData dataWithBytes:retByte length:length];
    sendData = [self encrypt:sendData];
    // 向蓝牙写入命令数据
    [self.cbPeripheral writeValue:sendData forCharacteristic:self.reportCharacteristic type:CBCharacteristicWriteWithResponse];
}

@end
