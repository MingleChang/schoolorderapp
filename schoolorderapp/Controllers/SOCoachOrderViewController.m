//
//  SOCoachOrderViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOCoachOrderViewController.h"
#import "MCDate.h"
#import "SONetwork.h"
#import "SOCoachPlan.h"
#import "SOPlan.h"
#import "SOPlanCell.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOOrder.h"
#import "SODateSelectView.h"
#import <MJRefresh/MJRefresh.h>

#define PLAN_CELL_ID @"SOPlanCell"

@interface SOCoachOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SODateSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectButton;

@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;

@property(nonatomic,copy)NSArray *planArray;
@property(nonatomic,weak)SOPlan *selectedPlan;

- (IBAction)lastDayButtonClick:(UIButton *)sender;
- (IBAction)nextDayButtonClick:(UIButton *)sender;
- (IBAction)dateSelectButtonClick:(UIButton *)sender;
- (IBAction)confirmButtonClick:(UIButton *)sender;

@end

@implementation SOCoachOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)headerRefresh:(id)sender{
    [self requestPlanList];
}
-(void)resetEmptyLabel{
    if (self.planArray.count==0) {
        [self setEmptyLabelHidden:NO];
    }else{
        [self setEmptyLabelHidden:YES];
    }
}
-(void)resetSelectDateButton{
    NSArray *lArray=@[@" 周日",@" 周一",@" 周二",@" 周三",@" 周四",@" 周五",@" 周六"];
    NSString *lStr=[self.selectDate formattedDateWithFormat:@"yy-MM-dd"];
    lStr=[lStr stringByAppendingString:[lArray objectAtIndex:self.selectDate.weekday-1]];
    [self.dateSelectButton setTitle:lStr forState:UIControlStateNormal];
}
- (IBAction)lastDayButtonClick:(UIButton *)sender {
    if([self.selectDate isSameDay:[MCDate date]]){
        [MBProgressHUD show:@"不能查看过期预约" view:self.view];
        return;
    }
    self.selectDate=[self.selectDate dateByAddDays:-1];
    [self resetSelectDateButton];
//    [self requestPlanList];
    [self.refreshHeader beginRefreshing];
}

- (IBAction)nextDayButtonClick:(UIButton *)sender {
    self.selectDate=[self.selectDate dateByAddDays:1];
    [self resetSelectDateButton];
//    [self requestPlanList];
    [self.refreshHeader beginRefreshing];
}
- (IBAction)dateSelectButtonClick:(UIButton *)sender{
    [SODateSelectView showWith:self andSelectDate:self.selectDate];
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.selectedPlan==nil) {
        return;
    }
    [self bookingRequest];
}
#pragma mark - Delegate
#pragma mark - UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.planArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOPlan *plan=[self.planArray objectAtIndex:row];
    SOPlanCell *lCell=[collectionView dequeueReusableCellWithReuseIdentifier:PLAN_CELL_ID forIndexPath:indexPath];
    [lCell setupPlan:plan];
    [lCell setupSelected:[plan isEqual:self.selectedPlan]];
    return lCell;
}
#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOPlan *plan=[self.planArray objectAtIndex:row];
    if (plan.can_order==NO) {
        return;
    }
    if ([plan isEqual:self.selectedPlan]) {
        return;
    }
    self.selectedPlan=plan;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionView Delegate FlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat lScreenWidth=[MCDevice screenWidth];
    CGFloat lWidth=(lScreenWidth-20-14)/3;
    return CGSizeMake(lWidth, lWidth/3*2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
#pragma mark - SODateSelectView Delegate
-(void)dateSelectView:(SODateSelectView *)view selectDate:(MCDate *)date{
    self.selectDate=date;
    [self resetSelectDateButton];
//    [self requestPlanList];
    [self.refreshHeader beginRefreshing];
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
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.collectionView.header=self.refreshHeader;
    
    [self.collectionView registerNib:[UINib nibWithNibName:PLAN_CELL_ID bundle:nil] forCellWithReuseIdentifier:PLAN_CELL_ID];
    [self resetSelectDateButton];
}
-(void)configureData{
    [self.refreshHeader beginRefreshing];
//    [self requestPlanList];
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
    self.title=@"预约列表";
}
#pragma mark - Network
-(void)requestPlanList{
    NSString *lDateStr=[self.selectDate formattedDateWithFormat:@"yyyy-MM-dd"];
    [SONetwork postWithProtocol:PLAN_LIST_PROTOCOL andParam:@{@"coach_id":self.coachPlan.coach_id,@"date":lDateStr} andProtocolID:PLAN_LIST_PROTOCOL_ID success:^(id data) {
        [self.refreshHeader endRefreshing];
        self.planArray=[SOPlan mj_objectArrayWithKeyValuesArray:data];
        self.selectedPlan=nil;
        [self.collectionView reloadData];
        [self resetEmptyLabel];
    } failed:^{
        [self.refreshHeader endRefreshing];
        [self resetEmptyLabel];
    }];
}
-(void)bookingRequest{
    NSDictionary *lDic=@{@"student_id":[SOManager manager].user.student_id,@"plan_id":self.selectedPlan.plan_id,@"coach_id":self.coachPlan.coach_id,@"platform":@"ios"};
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:ORDER_PROTOCOL andParam:lDic andProtocolID:ORDER_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
//        [self requestPlanList];
        [self.refreshHeader beginRefreshing];
//        SOOrder *lOrder=[SOOrder mj_objectWithKeyValues:data];
        [MBProgressHUD show:@"预约成功" view:self.view];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
