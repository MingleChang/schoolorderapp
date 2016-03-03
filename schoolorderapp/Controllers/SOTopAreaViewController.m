//
//  SOTopAreaViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/11.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOTopAreaViewController.h"
#import "SOTopAreaCell.h"
#import "SOArea.h"
#import "SOCommon.h"
#import "MCDevice.h"
#import "MBProgressHUD+HUDSHOW.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define TOP_AREA_CELL_ID @"SOTopAreaCell"

@interface SOTopAreaViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property(nonatomic,copy)NSDictionary *topAreaDic;

@end

@implementation SOTopAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setKeyboardManagerEnable:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setKeyboardManagerEnable:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Private Motheds
-(void)setKeyboardManagerEnable:(BOOL)enable{
    [[IQKeyboardManager sharedManager]setEnable:enable];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:enable];
}
-(void)analysisTopAreaWith:(NSString *)key{
    NSArray *lArray=nil;
    if (key.length==0) {
        lArray=[SOManager manager].topAreaArray;
    }else{
        NSString *lPredicateStr=[NSString stringWithFormat:@"area_name CONTAINS '%@'",key];
        NSPredicate *lPredicate=[NSPredicate predicateWithFormat:lPredicateStr];
        lArray=[[SOManager manager].topAreaArray filteredArrayUsingPredicate:lPredicate];
    }
    
    NSMutableDictionary *lDic=[NSMutableDictionary dictionary];
    for (SOArea *area in lArray) {
        NSString *lHeaderAlphabet=[SOCommon getHeaderAlphabet:area.area_name];
        if ([lDic.allKeys containsObject:lHeaderAlphabet]) {
            NSMutableArray *lArray=[lDic objectForKey:lHeaderAlphabet];
            [lArray addObject:area];
        }else{
            NSMutableArray *lArray=[NSMutableArray array];
            [lArray addObject:area];
            [lDic setObject:lArray forKey:lHeaderAlphabet];
        }
    }
    self.topAreaDic=lDic;
    [self.tableView reloadData];
}
-(SOArea *)getAreaWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    NSArray *lKeys=[self getAreaKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section];
    NSArray *lArray=[self.topAreaDic objectForKey:lKey];
    SOArea *lArea=lArray[row];
    return lArea;
}
-(NSArray *)getAreaKeyArray{
    NSArray *lKeys=[[self.topAreaDic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    return lKeys;
}
#pragma mark - UIKeyboardWillChangeFrame Notification
-(void)keyboardChangeFrame:(NSNotification *)notification{
    CGRect lFrame=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat lHeight=[MCDevice screenHeight]-lFrame.origin.y;
    self.tableViewBottomConstraint.constant=lHeight;
}

#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.topAreaDic.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *lKeys=[self getAreaKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section];
    NSArray *lArray=[self.topAreaDic objectForKey:lKey];
    return lArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SOArea *lArea=[self getAreaWithIndexPath:indexPath];
    SOTopAreaCell *lCell=[tableView dequeueReusableCellWithIdentifier:TOP_AREA_CELL_ID forIndexPath:indexPath];
    lCell.textLabel.text=lArea.area_name;
    return lCell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *lKeys=[self getAreaKeyArray];
    NSString *lKey=[lKeys objectAtIndex:section];
    return lKey;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self getAreaKeyArray];
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SOArea *lArea=[self getAreaWithIndexPath:indexPath];
    [[SOManager manager]selectTopAreaWith:lArea];
    [MBProgressHUD showSimpleHudtoView:self.view];
    [[SOManager manager]updateSchoolComplete:^{
        [MBProgressHUD hideHUDForView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:SELECT_AREA_NOTIICATION object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self analysisTopAreaWith:searchText];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
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
    [self.tableView registerNib:[UINib nibWithNibName:TOP_AREA_CELL_ID bundle:nil] forCellReuseIdentifier:TOP_AREA_CELL_ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)configureData{
    [self analysisTopAreaWith:nil];
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
    self.title=@"选择城市";
}
@end
