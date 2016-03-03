//
//  SODiscussViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SODiscussViewController.h"
#import "MJRefresh.h"
#import "SONetwork.h"
#import "SODiscussTableViewCell.h"
#import "SODiscussModel.h"
#import "SOMoreDiscussViewController.h"

#define CellIdentify @"SODiscussTableViewCell"

@interface SODiscussViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *allList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;
@property(nonatomic,strong)MJRefreshAutoFooter *refreshFooter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopSpace;

@end

@implementation SODiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configuration{
    allList = [NSMutableArray new];
    page = 1;
    [self.mainTable registerNib:[UINib nibWithNibName:CellIdentify bundle:nil] forCellReuseIdentifier:CellIdentify];
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.mainTable.header=self.refreshHeader;
    self.mainTable.tableFooterView = [UIView new];
    [self.refreshHeader beginRefreshing];
    self.refreshFooter=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh:)];
    self.mainTable.footer=self.refreshFooter;
    if (self.isHideTopView) {
        self.tableTopSpace.constant = -44;
    }
}

-(void)headerRefresh:(id)sender{
    page = 1;
    NSString *pageNo = [NSString stringWithFormat:@"%d",page];
    [SONetwork getWithProtocol:GET_DISCUSS_PROTOCOL(self.schoolModel.school_id,self.discussType,@"15",pageNo) andParam:nil success:^(id data) {
        [self.refreshHeader endRefreshing];
        allList = [[NSMutableArray alloc]initWithArray:[SODiscussModel mj_objectArrayWithKeyValuesArray:data]];
        if (allList.count!=0) {
            [self.mainTable reloadData];
        }
    } failed:^{
        
    }];
}

-(void)footerRefresh:(id)sender{
    page ++;
    NSString *pageNo = [NSString stringWithFormat:@"%d",page];
    [SONetwork getWithProtocol:GET_DISCUSS_PROTOCOL(self.schoolModel.school_id,self.discussType,@"15",pageNo) andParam:nil success:^(id data) {
        [self.refreshFooter endRefreshing];
        NSArray *temp = [SODiscussModel mj_objectArrayWithKeyValuesArray:data];
        if (temp.count!=0) {
            [allList addObjectsFromArray:temp];
            [self.mainTable reloadData];
        }
    } failed:^{
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SODiscussTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    [cell setCellWithObj:allList[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SODiscussTableViewCell getCellHeight:allList[indexPath.row]];
}

- (IBAction)getMoreDiscussAction:(UIButton *)sender {
    SOMoreDiscussViewController *more = [SOMoreDiscussViewController new];
    more.schoolModel = self.schoolModel;
    [self.navigationController pushViewController:more animated:YES];
    
}



@end
