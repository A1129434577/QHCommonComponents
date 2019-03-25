//
//  QHMapView.h
//  moonbox
//
//  Created by 刘彬 on 2018/12/7.
//  Copyright © 2018 刘彬. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic,strong)CLPlacemark *placemark;
@end

typedef NS_ENUM(NSUInteger, QHReverseGeocodeStatus) {
    QHReverseGeocodeStatusNormal = 0,
    QHReverseGeocodeStatusWorking,
    QHReverseGeocodeStatusFinished,
};

@protocol QHMapViewDelegate <NSObject>
@optional
-(void)reverseGeocodeStatusChanged:(QHReverseGeocodeStatus)state;

@end

@interface QHMapView : MKMapView

typedef NS_ENUM(NSUInteger, QHMapTapGestureAction) {
    AddAnnotation = 0,//点击添加地图标注点
    GPSNavigation,//点击导航
};
@property (nonatomic,strong)QHAnnotation *annotation;//当前标记点
@property (nonatomic,assign)CLLocationCoordinate2D regionCenter;
@property (nonatomic,assign,readonly)QHReverseGeocodeStatus state;
@property (nonatomic,assign)QHMapTapGestureAction tapGestureAction;

@property (nonatomic, weak, nullable) id <QHMapViewDelegate> qhDelegate;

- (instancetype)initWithFrame:(CGRect)frame showsUserLocation:(BOOL )abool;

-(void)setRegionWithCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

-(void)searchLocationWithText:(NSString *)text success:(void (^ _Nullable)(NSArray<QHAnnotation *> *pointAnnotations))success failure:(void (^ _Nullable)(NSString *errorMsg))failure;//检索地址
@end





NS_ASSUME_NONNULL_END
