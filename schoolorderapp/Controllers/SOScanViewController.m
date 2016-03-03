//
//  SOScanViewController.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOScanViewController.h"
#import "MCQRCode.h"

@interface SOScanViewController ()<MCQRCodeDelegate>
@property(nonatomic,strong)MCQRCode *sannerView;
@end

@implementation SOScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Delegate
#pragma mark - MCQRCode Delegate
-(void)qrCodeFinishedSanningQRCode:(NSString *)result{
    if ([self.delegate respondsToSelector:@selector(scanViewController:sannerQRCode:)]) {
        [self.delegate scanViewController:self sannerQRCode:result];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    CGRect lFrame=[UIScreen mainScreen].bounds;
    lFrame.size.height=lFrame.size.height-64;
    self.sannerView=[[MCQRCode alloc]initWithFrame:lFrame];
    self.sannerView.delegate=self;
    [self.view addSubview:self.sannerView];
}
-(void)configureData{
    
}

#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)resetNavigationBarItems{
    [super resetNavigationBarItems];
    self.title=@"扫一扫";
}
@end
