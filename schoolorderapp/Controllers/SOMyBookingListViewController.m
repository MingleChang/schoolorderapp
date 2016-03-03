//
//  SOMyBookingListViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMyBookingListViewController.h"
#import "SONetwork.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOMyBooking.h"
#import "SOMyBookingCell.h"
#import "SOCommentViewController.h"
#import "SOBookingDetailViewController.h"
#import "SOPayViewController.h"
#import <MJRefresh/MJRefresh.h>

#define MY_BOOKING_CELL_ID @"SOMyBookingCell"

@interface SOMyBookingListViewController ()<UITableViewDataSource,UITableViewDelegate,SOMyBookingCellDelegate>
@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSArray *bookingArray;
@end

@implementation SOMyBookingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(void)commentSuccessNotificaion:(NSNotification *)sender{
    [self.refreshHeader beginRefreshing];
}
-(void)paySuccessNotificaion:(NSNotification *)sender{
    [self.refreshHeader beginRefreshing];
}
-(void)orderCancelNotificaion:(NSNotification *)sender{
    [self.refreshHeader beginRefreshing];
}

#pragma mark - Private Mothed
-(void)headerRefresh:(id)sender{
    [self requestMyBooking];
    
}
-(void)resetEmptyLabel{
    if (self.bookingArray.count==0) {
        [self setEmptyLabelHidden:NO];
    }else{
        [self setEmptyLabelHidden:YES];
    }
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOMyBooking *lBooking=[self.bookingArray objectAtIndex:row];
    SOMyBookingCell *lCell=[tableView dequeueReusableCellWithIdentifier:MY_BOOKING_CELL_ID forIndexPath:indexPath];
    [lCell setupMyBooking:lBooking];
    lCell.delegate=self;
    return lCell;
}
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOMyBooking *lBooking=[self.bookingArray objectAtIndex:row];
    if (lBooking.study_phrase==0) {
        [MBProgressHUD show:@"预约已取消" view:self.view];
        return;
    }
    SOBookingDetailViewController *lViewController=[[SOBookingDetailViewController alloc]init];
    lViewController.myBooking=lBooking;
    [self.navigationController pushViewController:lViewController animated:YES];
}
#pragma mark - SOMyBookingCell Delegate
-(void)myBookingCell:(SOMyBookingCell *)cell payButtonClick:(SOMyBooking *)myBooking{
    SOPayViewController *lViewController=[[SOPayViewController alloc]init];
    lViewController.orderId=myBooking.order_id;
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)myBookingCell:(SOMyBookingCell *)cell discussButtonClick:(SOMyBooking *)myBooking{
    SOCommentViewController *lViewController=[[SOCommentViewController alloc]init];
    lViewController.myBooking=myBooking;
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)myBookingCell:(SOMyBookingCell *)cell cancelButtonClick:(SOMyBooking *)myBooking{
    [self requestCancelOrder:myBooking];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentSuccessNotificaion:) name:COMMENT_SUCCESS_NOTICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessNotificaion:) name:PAY_SUCCESS_NOTICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderCancelNotificaion:) name:ORDER_CANCEL_NOTICATION object:nil];
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.tableView.header=self.refreshHeader;
    [self.tableView registerNib:[UINib nibWithNibName:MY_BOOKING_CELL_ID bundle:nil] forCellReuseIdentifier:MY_BOOKING_CELL_ID];
}
-(void)configureData{
    [self.refreshHeader beginRefreshing];
}
#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Network
-(void)requestMyBooking{
//    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork getWithProtocol:RESERVATINONS_PROTOCOL(@(self.type)) andParam:nil success:^(id data) {
//        [MBProgressHUD hideHUDForView:self.view];
        [self.refreshHeader endRefreshing];
        self.bookingArray=[SOMyBooking mj_objectArrayWithKeyValuesArray:data];
        [self.tableView reloadData];
        [self resetEmptyLabel];
    } failed:^{
//        [MBProgressHUD hideHUDForView:self.view];
        [self resetEmptyLabel];
    }];
}
-(void)requestCancelOrder:(SOMyBooking *)booking{
    NSDictionary *lDic=@{@"order_id":booking.id,@"cancel_cause":@(0)};
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:ORDER_CANCEL_PROTOCOL andParam:lDic andProtocolID:ORDER_CANCEL_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [self requestMyBooking];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
