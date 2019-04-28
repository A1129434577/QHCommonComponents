//
//  QHMapView.m
//  moonbox
//
//  Created by 刘彬 on 2018/12/7.
//  Copyright © 2018 刘彬. All rights reserved.
//

#import "QHMapView.h"
@implementation QHAnnotation
@end

@interface QHMapView()<MKMapViewDelegate>

@end
@implementation QHMapView
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame showsUserLocation:NO];
}
- (instancetype)initWithFrame:(CGRect)frame showsUserLocation:(BOOL )abool
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsUserLocation = abool;
        self.delegate = self;
    }
    return self;
}

-(void)setState:(QHReverseGeocodeStatus)state{
    _state = state;
    if ([self.qhDelegate respondsToSelector:@selector(reverseGeocodeStatusChanged:)]) {
        [self.qhDelegate reverseGeocodeStatusChanged:state];
    }
}

- (void)setTapGestureAction:(QHMapTapGestureAction)tapGestureAction{
    _tapGestureAction = tapGestureAction;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:tapGestureAction==AddAnnotation?@selector(addTheAnnotationInGesturePoint:):@selector(mapNavigation)];
    [self addGestureRecognizer:tapGesture];
}

-(void)addTheAnnotationInGesturePoint:(UILongPressGestureRecognizer *)gesture
{
    self.state = QHReverseGeocodeStatusWorking;
    CGPoint point = [gesture locationInView:self];
    CLLocationCoordinate2D coordinate = [self convertPoint:point toCoordinateFromView:self];//通过点转化为其经纬度坐标
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks,NSError *error){
        CLPlacemark *placemark = placemarks.firstObject;
        
        QHAnnotation *annotation = [[QHAnnotation alloc] init];
        annotation.placemark = placemark;
        annotation.coordinate = placemark.location.coordinate;
        annotation.title = placemark.name;
        annotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@",placemark.administrativeArea?placemark.administrativeArea:@"",placemark.locality?placemark.locality:@"",placemark.subLocality?placemark.subLocality:@"",placemark.thoroughfare?placemark.thoroughfare:@"",placemark.subThoroughfare?placemark.subThoroughfare:@""];
        weakSelf.annotation = annotation;
        weakSelf.state = QHReverseGeocodeStatusFinished;
    }];//获取信息
}

-(void)mapNavigation{
    UIAlertController *rephotographAlert = [UIAlertController alertControllerWithTitle:@"请选择地图进行导航" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [rephotographAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];

    __weak typeof(self) weakSelf = self;
    [[self getInstalledMapAppWithEndLocation:_annotation.coordinate] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rephotographAlert addAction:[UIAlertAction actionWithTitle:obj[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqual:@"苹果地图"]) {
                [MKMapItem openMapsWithItems:@[[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:weakSelf.annotation.coordinate addressDictionary:nil]]] launchOptions:nil];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj[@"url"]]];
            }
        }]];
    }];
    // 遍历响应者链。返回第一个找到视图控制器
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            [(UIViewController *)responder presentViewController:rephotographAlert animated:YES completion:NULL];
            break;
        }
    }
    
}
#pragma mark - 导航方法
- (NSArray<NSDictionary *> *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {  
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}
- (void)setAnnotation:(QHAnnotation *)annotation{
    _annotation = annotation;
    self.showsUserLocation = NO;
    
    [self removeAnnotations:self.annotations];
    [self showAnnotations:@[annotation] animated:YES];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf selectAnnotation:annotation animated:YES];
    });
    
    self.regionCenter = annotation.coordinate;
}

-(void)setRegionCenter:(CLLocationCoordinate2D)regionCenter{
    _regionCenter = regionCenter;
    [self setRegionWithCoordinate:regionCenter animated:YES];
}

-(void)setRegionWithCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated{
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
        [self setRegion:MKCoordinateRegionMake(coordinate, span) animated:animated];
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //设置地图显示范围
    if (CGPointEqualToPoint(CGPointMake(self.regionCenter.latitude, self.regionCenter.longitude), CGPointZero)) {
        [self setRegionWithCoordinate:userLocation.coordinate animated:YES];
    }
    self.state = QHReverseGeocodeStatusWorking;
    
    __weak typeof(self) weakSelf = self;
    //开始检索定位到的地址
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks,NSError *error){
        CLPlacemark *placemark = placemarks.firstObject;

        QHAnnotation *annotation = [[QHAnnotation alloc] init];
        annotation.placemark = placemark;
        annotation.coordinate = placemark.location.coordinate;
        annotation.title = placemark.name;
        annotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@",placemark.administrativeArea?placemark.administrativeArea:@"",placemark.locality?placemark.locality:@"",placemark.subLocality?placemark.subLocality:@"",placemark.thoroughfare?placemark.thoroughfare:@"",placemark.subThoroughfare?placemark.subThoroughfare:@""];
        
        weakSelf.annotation = annotation;
        weakSelf.state = QHReverseGeocodeStatusFinished;
    }];
}


-(void)searchLocationWithText:(NSString *)text success:(void (^ _Nullable)(NSArray<QHAnnotation *> * _Nonnull))success failure:(void (^ _Nullable)(NSString * _Nonnull))failure{
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init] ;
    //设置搜索范围
    localSearchRequest.region = self.region;
    localSearchRequest.naturalLanguageQuery = text;//搜索关键词
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error)
        {
            failure?failure(error.localizedDescription):NULL;
        }
        else
        {
            NSMutableArray<QHAnnotation *> *annotations = [[NSMutableArray alloc] init];
            [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MKPlacemark *placemark = obj.placemark;
                QHAnnotation *annotation = [[QHAnnotation alloc] init];
                annotation.placemark = placemark;
                annotation.coordinate = placemark.coordinate;
                annotation.title = placemark.name;
                annotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@%@",placemark.administrativeArea?placemark.administrativeArea:@"",placemark.locality?placemark.locality:@"",placemark.subLocality?placemark.subLocality:@"",placemark.thoroughfare?placemark.thoroughfare:@"",placemark.subThoroughfare?placemark.subThoroughfare:@""];
                [annotations addObject:annotation];
            }];
        success?success(annotations):NULL;
            
        }
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"identifier";
    MKAnnotationView *newAnnotation = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!newAnnotation) {
        
        newAnnotation = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        
        newAnnotation.canShowCallout = YES;//显示气泡视图
        newAnnotation.image = [UIImage imageNamed:@"location_green"];
    }
    return newAnnotation;
}


@end


