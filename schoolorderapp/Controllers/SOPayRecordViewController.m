//
//  SOPayRecordViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPayRecordViewController.h"
#import "SOPayRecordCell.h"
#import "SONetwork.h"
#import "SOTrade.h"
#import "SOTradePayDetail.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOPayViewController.h"
#import <MJRefresh/MJRefresh.h>

#define PAY_RECORD_CELL_ID @"SOPayRecordCell"

@interface SOPayRecordViewController ()<SOPayRecordCellDelegate>
@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSArray *tradeArray;

@end

@implementation SOPayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(void)paySuccessNotificaion:(NSNotification *)sender{
    [self.refreshHeader beginRefreshing];
}
#pragma mark - Private Motheds
-(void)headerRefresh:(id)sender{
    [self requestPayRecordList];
}
-(void)resetEmptyLabel{
    if (self.tradeArray.count==0) {
        [self setEmptyLabelHidden:NO];
    }else{
        [self setEmptyLabelHidden:YES];
    }
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tradeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOTrade *lTrade=self.tradeArray[row];
    SOPayRecordCell *lCell=[tableView dequeueReusableCellWithIdentifier:PAY_RECORD_CELL_ID forIndexPath:indexPath];
    lCell.delegate=self;
    [lCell setupTrade:lTrade];
    return lCell;
}
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOTrade *lTrade=self.tradeArray[row];
    return [SOPayRecordCell getCellHeightWith:lTrade];
}

#pragma mark - SOPayRecordCell Delegate
-(void)payRecordCell:(SOPayRecordCell *)cell buttonClickWith:(SOTrade *)trade{
    SOPayViewController *lViewController=[[SOPayViewController alloc]init];
    lViewController.orderId=trade.order_id;
    [self.navigationController pushViewController:lViewController animated:YES];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessNotificaion:) name:PAY_SUCCESS_NOTICATION object:nil];
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.tableView.header=self.refreshHeader;
    [self.tableView registerNib:[UINib nibWithNibName:PAY_RECORD_CELL_ID bundle:nil] forCellReuseIdentifier:PAY_RECORD_CELL_ID];
}
-(void)configureData{
//    [self requestPayRecordList];
    [self.refreshHeader beginRefreshing];
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
    self.title=@"消费记录";
}

#pragma mark - Network Request
-(void)requestPayRecordList{
//    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork getWithProtocol:PAYLIST_PROTOCOL([SOManager manager].user.student_id,self.type) andParam:nil success:^(id data) {
//        [MBProgressHUD hideHUDForView:self.view];
        [self.refreshHeader endRefreshing];
        self.tradeArray=[SOTrade mj_objectArrayWithKeyValuesArray:data];
        [self.tableView reloadData];
        [self resetEmptyLabel];
    } failed:^{
//        [MBProgressHUD hideHUDForView:self.view];
        [self resetEmptyLabel];
    }];
}
@end
