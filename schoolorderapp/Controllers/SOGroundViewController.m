//
//  SOGroundViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOGroundViewController.h"
#import "MJRefresh.h"
#import "SONetwork.h"
#import "SOGroundModel.h"

#define CellIdentify @"GroundCell"

@interface SOGroundViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *allList;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property(nonatomic,strong)MJRefreshNormalHeader *refreshHeader;

@end

@implementation SOGroundViewController

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
   // [self.mainTable registerNib:[UINib nibWithNibName:CellIdentify bundle:nil] forCellReuseIdentifier:CellIdentify];
    self.refreshHeader=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh:)];
    self.mainTable.header=self.refreshHeader;
    self.mainTable.tableFooterView = [UIView new];
    [self.refreshHeader beginRefreshing];

}

-(void)headerRefresh:(id)sender{
    [SONetwork getWithProtocol:GET_GROUND_PROTOCOL(self.schoolModel.school_id) andParam:nil success:^(id data) {
        [self.refreshHeader endRefreshing];
        allList = [SOGroundModel mj_objectArrayWithKeyValuesArray:data];
        if (allList.count!=0) {
            [self.mainTable reloadData];
        }
    } failed:^{
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SOGroundModel *model = [allList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.placeAddr;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
