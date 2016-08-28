//
//  ViewController.m
//  BaiduMapSDK
//
//  Created by 王壮 on 16/8/27.
//  Copyright © 2016年 王壮. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>

@interface ViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) UIImageView *centerImgV;
@property (nonatomic,strong) BMKPinAnnotationView* annotationView;
@property (nonatomic,assign) CLLocationCoordinate2D coor;
@property (nonatomic,strong) BMKPointAnnotation *pointAnnotation;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    
    CGPoint center = [_mapView convertCoordinate:_mapView.centerCoordinate toPointToView:self.view];
    _centerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Position"]];
    _centerImgV.center = center;
    _centerImgV.hidden = YES;
    [self.view addSubview:_centerImgV];
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    _locationService.distanceFilter = 100;
    [_locationService startUserLocationService];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    _coor.latitude = userLocation.location.coordinate.latitude;
    _coor.longitude = userLocation.location.coordinate.longitude;
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        _annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        _annotationView.image = [UIImage imageNamed:@"Position"];
        return _annotationView;
    }
    
    return nil;
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {

    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = _coor;
    _pointAnnotation.coordinate = _mapView.centerCoordinate;
    _pointAnnotation.title = @"我的位置";
    [_mapView addAnnotation:_pointAnnotation];
    self.mapView.zoomLevel = 18;
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
        [_mapView removeAnnotation:_pointAnnotation];
        CGPoint center = [_mapView convertCoordinate:_mapView.centerCoordinate toPointToView:self.view];
        _centerImgV.center = CGPointMake(center.x, center.y-24);
        _centerImgV.hidden = NO;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CGPoint center = [_mapView convertCoordinate:_mapView.centerCoordinate toPointToView:self.view];
    _centerImgV.center = CGPointMake(center.x, center.y);
    _centerImgV.hidden = YES;

    _pointAnnotation.coordinate = _coor;
    _pointAnnotation.coordinate = _mapView.centerCoordinate;
    _pointAnnotation.title = @"我的位置";
    [_mapView addAnnotation:_pointAnnotation];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

@end