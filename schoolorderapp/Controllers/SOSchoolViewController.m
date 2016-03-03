//
//  SOSchoolViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSchoolViewController.h"
#import "SOSchoolListTableViewCell.h"
#import "SONetwork.h"
#import "SOSchoolListModel.h"
#import "SOAreaSelectView.h"
#import "SOSearchViewController.h"
#import "SOSchoolDetailViewController.h"

#define CellNibName @"SOSchoolListTableViewCell"
#define CellIdentify @"SOSchoolListTableViewCell"

@interface SOSchoolViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *allList;
}
@property (weak, nonatomic) IBOutlet UILabel *aeraLab;

@end

@implementation SOSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(void)configuration{
    [self.mainTable registerNib:[UINib nibWithNibName:CellNibName bundle:nil] forCellReuseIdentifier:CellIdentify];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectAreaNotification:) name:SELECT_AREA_NOTIICATION object:nil];
}

-(void)getData{
    NSDictionary *Param = @{@"schoolName":@"",@"areaCode":[SOManager manager].selectedSubArea.area_code,@"pageNo":@1,@"pageSize":@1000};
    [SONetwork postWithProtocol:SCHOOL_List andParam:Param andProtocolID:@"SCHOOLLIST" success:^(id data) {
        MCLOG(@"%@",data);
        allList = [SOSchoolListModel mj_objectArrayWithKeyValuesArray:data];
        [SOManager manager].schoolArray = [[NSArray alloc]initWithArray:allList];
        [self.mainTable reloadData];
    } failed:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SOManager manager].schoolArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOSchoolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    [cell setCellDetailWithObj:[SOManager manager].schoolArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SOSchoolListTableViewCell getCellHeightWithObj:[SOManager manager].schoolArray[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SOSchoolDetailViewController *detail = [SOSchoolDetailViewController new];
    detail.schoolModel = [SOManager manager].schoolArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)showAreaViewAction:(UIButton *)sender {
    [SOAreaSelectView showWithViewController:self];
}
- (IBAction)searchBtnAction:(UIButton *)sender {
    SOSearchViewController *search = [SOSearchViewController new];
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
    [self.navigationController pushViewController:search animated:YES];
    
}

-(void)selectAreaNotification:(NSNotification*)notify{
    self.aeraLab.text = [SOManager manager].selectedSubArea.area_name;
    [self.mainTable reloadData];
}

@end
