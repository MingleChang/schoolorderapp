//
//  SOSearchViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSearchViewController.h"
#import "SOSchoolListTableViewCell.h"
#import "IQKeyboardManager.h"

#define CellNibName @"SOSchoolListTableViewCell"
#define CellIdentify @"SOSchoolListTableViewCell"

@interface SOSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSArray *allList;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *disMissBtn;

@end

@implementation SOSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
}

-(void)configuration{
    self.navigationItem.title = @"驾校查询";
    [self.mainTable registerNib:[UINib nibWithNibName:CellNibName bundle:nil] forCellReuseIdentifier:CellIdentify];
    self.mainTable.tableFooterView = [UIView new];
}

-(void)resetNavigationBarStatus{
    [super resetNavigationBarStatus];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [manager setEnable:NO];
    [manager setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [manager setEnable:YES];
    [manager setEnableAutoToolbar:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOSchoolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    [cell setCellDetailWithObj:allList[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SOSchoolListTableViewCell getCellHeightWithObj:allList[indexPath.row]];
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.disMissBtn.hidden = NO;
    MCLOG(@"显示");
}

- (IBAction)searchBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    self.disMissBtn.hidden = YES;
    NSString *key = self.searchBarView.text;
    NSString *lPredicateStr=[NSString stringWithFormat:@"schoolName CONTAINS '%@'",key];
    NSPredicate *lPredicate=[NSPredicate predicateWithFormat:lPredicateStr];
    allList=[[SOManager manager].schoolArray filteredArrayUsingPredicate:lPredicate];
    [self.mainTable reloadData];
}

- (IBAction)disMissKeyBorad:(id)sender {
    [self.view endEditing:YES];
    self.disMissBtn.hidden = YES;
}

@end
