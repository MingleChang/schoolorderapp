//
//  SOBookingDetailViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/21.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOBookingDetailViewController.h"
#import "SOMyBooking.h"
#import "MCDateExtension.h"
#import "SOProgessView.h"
#import "SONetwork.h"
#import "MBProgressHUD+HUDSHOW.h"

@interface SOBookingDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *kemuLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet SOProgessView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
- (IBAction)cancelButtonClick:(UIButton *)sender;

@end

@implementation SOBookingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event Response
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self cancelOrder];
}
#pragma mark - Private Motheds
-(void)resetSubView{
    [self.progressView setupStatus:self.myBooking.study_phrase];
    self.coachNameLabel.text=self.myBooking.coach_name;
    self.coachPhoneLabel.text=self.myBooking.coach_phone;
    NSString *lKemu=nil;
    if ([self.myBooking.subject isEqualToString:@"km1"]) {
        lKemu=@"科目一";
    }else if ([self.myBooking.subject isEqualToString:@"km2"]) {
        lKemu=@"科目二";
    }else if ([self.myBooking.subject isEqualToString:@"km3"]) {
        lKemu=@"科目三";
    }else{
        lKemu=@"科目四";
    }
    self.kemuLabel.text=lKemu;
    NSDate *lPlanDate=[NSDate fromString:self.myBooking.plan_date withFormat:@"yyyy-MM-dd HH:mm:ss" withTimeZone:nil];
    self.dateLabel.text=[NSString stringWithFormat:@"%@ %@-%@",[lPlanDate toStringWithFormat:@"yy-MM-dd" withTimeZone:nil],self.myBooking.start_time,self.myBooking.end_time];
    self.priceLabel.text=[NSString stringWithFormat:@"%@(%0.1f元)-%@",self.myBooking.pay_type,self.myBooking.fee,[self.myBooking.pay_status isEqualToString:@"10"]?@"交易完成":@"待付款"];
    self.orderStatusLabel.text=self.myBooking.res_message;
    NSDate *lCreateDate=[NSDate fromString:self.myBooking.create_time withFormat:@"yyyy-MM-dd HH:mm:ss" withTimeZone:nil];
    self.createDateLabel.text=[lCreateDate toStringWithFormat:@"yy-MM-dd HH:mm" withTimeZone:nil];
    self.cancelButton.hidden=!self.myBooking.can_cancel;
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
    self.lineHeightConstraint.constant=ONE_PIXEL;
    [self resetSubView];
}
-(void)configureData{
    [self requestBookingInfo];
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
    self.title=@"预约详情";
}
#pragma mark - Network
-(void)cancelOrder{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:ORDER_CANCEL_PROTOCOL andParam:@{@"order_id":self.myBooking.id,@"cancel_cause":@(0)} andProtocolID:ORDER_CANCEL_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:ORDER_CANCEL_NOTICATION object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD show:@"取消成功" view:[UIApplication sharedApplication].keyWindow];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)requestBookingInfo{
    [SONetwork getWithProtocol:GET_RESERVATION_PROTOCOL(self.myBooking.id) andParam:nil success:^(id data) {
        self.myBooking=[SOMyBooking mj_objectWithKeyValues:data[@"res_info"]];
        [self resetSubView];
    } failed:^{
        
    }];
}
@end
