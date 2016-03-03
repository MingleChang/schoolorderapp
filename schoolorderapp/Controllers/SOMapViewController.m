//
//  SOMapViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/21.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMapViewController.h"
#import <MapKit/MapKit.h>

@interface SOMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMap;

@end

@implementation SOMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.schoolModel.latitude;
    coordinate.longitude = self.schoolModel.longitude;
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    [ann setTitle:self.schoolModel.schoolName];
    //触发viewForAnnotation
    [self.mainMap addAnnotation:ann];
    
    //设置显示范围
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    region.center = coordinate;
    // 设置显示位置(动画)
    [self.mainMap setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [self.mainMap regionThatFits:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
