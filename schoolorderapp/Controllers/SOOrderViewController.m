//
//  SOOrderViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOOrderViewController.h"
#import "SOAreaSelectView.h"
#import "SOSortView.h"
#import "SOFilterView.h"
#import "SOOrderCell.h"
#import "MCDateExtension.h"
#import "SONetwork.h"
#import "SOCoachPlan.h"
#import "MCDate.h"
#import "SOCoachOrderViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SODateSelectView.h"
#import <MJRefresh/MJRefresh.h>

#define ORDER_CELL_ID @"SOOrderCell"

#define PAGE_COUNT 10

@interface SOOrderViewController ()<SOFilterViewDelegate,SOSortViewDelegate,UITableViewDataSource,UITableViewDelegate,SODateSelectViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidthConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectButton;

@property(nonatomic,strong)MJRefreshBackNormalFooter *refreshFooter;
@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;

@property(nonatomic,strong)MCDate *selectDate;

@property(nonatomic,assign)NSInteger pageIndex;

@property(nonatomic,strong)NSMutableArray *coachPlanArray;


- (IBAction)areaSelectButtonClick:(UIButton *)sender;
- (IBAction)sortButtonClick:(UIButton *)sender;
- (IBAction)filterButtonClick:(UIButton *)sender;
- (IBAction)lastDayButtonClick:(UIButton *)sender;
- (IBAction)nextDayButtonClick:(UIButton *)sender;
- (IBAction)dateSelectButtonClick:(UIButton *)sender;

@end

@implementation SOOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)resetEmptyLabel{
    if (self.coachPlanArray.count==0) {
        [self setEmptyLabelHidden:NO];
    }else{
        [self setEmptyLabelHidden:YES];
    }
}
-(void)headerRefresh:(id)sender{
    self.pageIndex=1;
    [self headerRequestCoachPlan];
}
-(void)footerRefresh:(id)sender{
    [self footerRequestCoachPlan];
}
-(void)resetSelectDateButton{
    NSArray *lArray=@[@" 周日",@" 周一",@" 周二",@" 周三",@" 周四",@" 周五",@" 周六"];
    NSString *lStr=[self.selectDate formattedDateWithFormat:@"yy-MM-dd"];
    lStr=[lStr stringByAppendingString:[lArray objectAtIndex:self.selectDate.weekday-1]];
    [self.dateSelectButton setTitle:lStr forState:UIControlStateNormal];
}
#pragma mark - Notification
-(void)selectAreaNotification:(NSNotification *)sender{
    self.areaLabel.text=[SOManager manager].selectedSubArea.area_name;
    [self.refreshHeader beginRefreshing];
}
#pragma mark - Event Response
- (IBAction)areaSelectButtonClick:(UIButton *)sender {
    [SOAreaSelectView showWithViewController:self];
}

- (IBAction)sortButtonClick:(UIButton *)sender {
    [SOSortView showWith:self];
}

- (IBAction)filterButtonClick:(UIButton *)sender {
    [SOFilterView showWith:self];
}

- (IBAction)lastDayButtonClick:(UIButton *)sender {
    if([self.selectDate isSameDay:[MCDate date]]){
        [MBProgressHUD show:@"不能查看过期预约" view:self.view];
        return;
    }
    self.selectDate=[self.selectDate dateByAddDays:-1];
    [self resetSelectDateButton];
    [self.refreshHeader beginRefreshing];
}

- (IBAction)nextDayButtonClick:(UIButton *)sender {
    self.selectDate=[self.selectDate dateByAddDays:1];
    [self resetSelectDateButton];
    [self.refreshHeader beginRefreshing];
}

- (IBAction)dateSelectButtonClick:(UIButton *)sender {
    [SODateSelectView showWith:self andSelectDate:self.selectDate];
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.coachPlanArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOCoachPlan *lPlan=[self.coachPlanArray objectAtIndex:row];
    SOOrderCell *lCell=[tableView dequeueReusableCellWithIdentifier:ORDER_CELL_ID forIndexPath:indexPath];
    [lCell setupCoachPlan:lPlan];
    return lCell;
}
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOCoachPlan *lPlan=[self.coachPlanArray objectAtIndex:row];
    if(lPlan.can_order==YES){
        SOCoachOrderViewController *lViewController=[[SOCoachOrderViewController alloc]init];
        lViewController.selectDate=self.selectDate;
        lViewController.coachPlan=lPlan;
        [self.navigationController pushViewController:lViewController animated:YES];
    }
}
#pragma mark - SOFilterView Delegate
-(void)fileViewOkClick:(SOFilterView *)view{
    [self.refreshHeader beginRefreshing];
}
#pragma mark - SOSortView Delegate
-(void)sortViewSelectSort:(SOSortView *)view{
    self.sortLabel.text=[SOManager manager].selectSort.sort_name;
    [self.refreshHeader beginRefreshing];
}
#pragma mark - SODateSelectView Delegate
-(void)dateSelectView:(SODateSelectView *)view selectDate:(MCDate *)date{
    self.selectDate=date;
    [self resetSelectDateButton];
    [self.refreshHeader beginRefreshing];
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.dateSelectButton.layer.cornerRadius=4;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectAreaNotification:) name:SELECT_AREA_NOTIICATION object:nil];
    self.lineWidthConstraint.constant=ONE_PIXEL;
    [self.tableView registerNib:[UINib nibWithNibName:ORDER_CELL_ID bundle:nil] forCellReuseIdentifier:ORDER_CELL_ID];
    
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.tableView.header=self.refreshHeader;
    
    self.refreshFooter=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh:)];
    self.tableView.footer=self.refreshFooter;
}
-(void)configureData{
    self.selectDate=[MCDate date];
    [self resetSelectDateButton];
    self.areaLabel.text=[SOManager manager].selectedSubArea.area_name;
    self.sortLabel.text=[SOManager manager].selectSort.sort_name;
    [self.refreshHeader beginRefreshing];
}
#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Network
-(NSDictionary *)getRequestParam{
    NSMutableDictionary *lDic=[NSMutableDictionary dictionary];
    if ([SOManager manager].filterTeacherName.length>0) {
        [lDic setObject:[SOManager manager].filterTeacherName forKey:@"coach"];
    }
    if ([SOManager manager].filterKemu.length>0) {
        [lDic setObject:[SOManager manager].filterKemu forKey:@"km"];
    }
    if ([SOManager manager].filterType.length>0) {
        [lDic setObject:[SOManager manager].filterType forKey:@"car_type"];
    }
    if ([SOManager manager].selectSort) {
        [lDic setObject:@([SOManager manager].selectSort.sort_code) forKey:@"sort"];
    }
    if ([SOManager manager].filterSchool.school_id.length>0) {
        [lDic setObject:[SOManager manager].filterSchool.school_id forKey:@"school_id"];
    }
    [lDic setObject:[SOManager manager].selectedSubArea.area_code forKey:@"area_code"];
    [lDic setObject:[self.selectDate formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"date"];
    [lDic setObject:@(PAGE_COUNT) forKey:@"page_size"];
    [lDic setObject:@(self.pageIndex) forKey:@"page_no"];
    return [lDic copy];
}
-(void)headerRequestCoachPlan{
    [SONetwork postWithProtocol:COACH_PLAN_PROTOCOL andParam:[self getRequestParam] andProtocolID:COACH_PLAN_PROTOCOL_ID success:^(id data) {
        self.coachPlanArray=[SOCoachPlan mj_objectArrayWithKeyValuesArray:data];
        if (self.coachPlanArray.count<PAGE_COUNT) {
            [self.refreshFooter noticeNoMoreData];
        }else{
            [self.refreshFooter resetNoMoreData];
        }
        self.pageIndex=2;
        [self.tableView reloadData];
        [self.refreshHeader endRefreshing];
        [self resetEmptyLabel];
    } failed:^{
        [self.refreshHeader endRefreshing];
        [self resetEmptyLabel];
    }];
}
-(void)footerRequestCoachPlan{
    [SONetwork postWithProtocol:COACH_PLAN_PROTOCOL andParam:[self getRequestParam] andProtocolID:COACH_PLAN_PROTOCOL_ID success:^(id data) {
        NSArray *lArray=[SOCoachPlan mj_objectArrayWithKeyValuesArray:data];
        [self.coachPlanArray addObjectsFromArray:lArray];
        self.pageIndex++;
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
        if (lArray.count<PAGE_COUNT) {
            [self.refreshFooter noticeNoMoreData];
        }
        [self resetEmptyLabel];
    } failed:^{
        [self.refreshFooter endRefreshing];
        [self resetEmptyLabel];
    }];
}
@end
