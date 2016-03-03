//
//  SOUserViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOUserViewController.h"
#import "SOUserInfoCell.h"
#import "SOLoginCell.h"
#import "SOUserSelectCell.h"
#import "SOLogoutCell.h"
#import "SOMyAccountsViewController.h"
#import "SOLoginViewController.h"
#import "SOChangePwdViewController.h"
#import "SOMyBookingViewController.h"
#import "SOScanViewController.h"
#import "SONetwork.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOQRCodeShowView.h"
#import "QRCScanner.h"

#define USER_INFO_CELL_ID @"SOUserInfoCell"
#define LOGIN_CELL_ID @"SOLoginCell"
#define USER_SELECT_CELL_ID @"SOUserSelectCell"
#define LOGOUT_CELL_ID @"SOLogoutCell"

@interface SOUserViewController ()<UITableViewDataSource,UITableViewDelegate,SOLoginCellDelegate,SOLogoutCellDelegate,SOUserInfoCellDelegate,SOScanViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSArray *infoArray;

@property(nonatomic,assign)BOOL isLogin;

@end

@implementation SOUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Motheds
#pragma mark -
-(void)enterLogin{
    SOLoginViewController *lViewController=[[SOLoginViewController alloc]init];
    UINavigationController *lNavigationController=[[UINavigationController alloc]initWithRootViewController:lViewController];
    [self.rdv_tabBarController presentViewController:lNavigationController animated:YES completion:nil];
}
-(void)selectBookingCell{
    if ([SOManager manager].user.student_id.length==0) {
        [self enterLogin];
        return;
    }
    SOMyBookingViewController *lViewController=[[SOMyBookingViewController alloc]init];
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)selectAccountsCell{
    if ([SOManager manager].user.student_id.length==0) {
        [self enterLogin];
        return;
    }
    SOMyAccountsViewController *lViewController=[[SOMyAccountsViewController alloc]init];
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)selectChangepwdCell{
    if ([SOManager manager].user.student_id.length==0) {
        [self enterLogin];
        return;
    }
    SOChangePwdViewController *lViewController=[[SOChangePwdViewController alloc]init];
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)selectScanCell{
    if ([SOManager manager].user.student_id.length==0) {
        [self enterLogin];
        return;
    }
    SOScanViewController *lViewController=[[SOScanViewController alloc]init];
    lViewController.delegate=self;
    [self.navigationController pushViewController:lViewController animated:YES];
}
-(void)selectSystemCell{
    
}
#pragma mark - About TableView Cell
-(UITableViewCell *)getUserOrLoginCellWithIndexPath:(NSIndexPath *)indexPath{
    if([SOManager manager].isLogin){
        SOUserInfoCell *lCell=[self.tableView dequeueReusableCellWithIdentifier:USER_INFO_CELL_ID forIndexPath:indexPath];
        [lCell updateUserView];
        lCell.delegate=self;
        return lCell;
    }else{
        SOLoginCell *lCell=[self.tableView dequeueReusableCellWithIdentifier:LOGIN_CELL_ID forIndexPath:indexPath];
        lCell.delegate=self;
        return lCell;
    }
}
-(UITableViewCell *)getUserSelectCellWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    NSArray *lArray=[self.infoArray objectAtIndex:section-1];
    NSDictionary *lDic=[lArray objectAtIndex:row];
    SOUserSelectCell *lCell=[self.tableView dequeueReusableCellWithIdentifier:USER_SELECT_CELL_ID forIndexPath:indexPath];
    [lCell setupInfo:lDic showOneLine:(row!=0)];
    return lCell;
}
-(UITableViewCell *)getLogoutCellWithIndexPath:(NSIndexPath *)indexPath{
    SOLogoutCell *lCell=[self.tableView dequeueReusableCellWithIdentifier:LOGOUT_CELL_ID forIndexPath:indexPath];
    lCell.delegate=self;
    return lCell;
}
-(void)clickUserSelectCellWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    NSArray *lArray=[self.infoArray objectAtIndex:section-1];
    NSDictionary *lDic=[lArray objectAtIndex:row];
    UserSelectType type=[[lDic objectForKey:USER_SELECT_TYPE_KEY]integerValue];
    switch (type) {
        case UserSelectTypeBooking:
            [self selectBookingCell];
            break;
        case UserSelectTypeAccounts:
            [self selectAccountsCell];
            break;
        case UserSelectTypeChangepwd:
            [self selectChangepwdCell];
            break;
        case UserSelectTypeScan:
            [self selectScanCell];
            break;
        case UserSelectTypeSystem:
            [self selectSystemCell];
            break;
        default:
            break;
    }
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.infoArray.count+([SOManager manager].isLogin?2:1);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section<=self.infoArray.count){
        NSArray *lArray=self.infoArray[section-1];
        return lArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=[indexPath section];
    if (section==0) {
        return [self getUserOrLoginCellWithIndexPath:indexPath];
    }else if(section<=self.infoArray.count){
        return [self getUserSelectCellWithIndexPath:indexPath];
    }else{
        return [self getLogoutCellWithIndexPath:indexPath];
    }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=[indexPath section];
    if (section==0) {
        return 100;
    }else if(section<=self.infoArray.count){
        return 50;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section=[indexPath section];
    if (section>0&&section<=self.infoArray.count) {
        [self clickUserSelectCellWithIndexPath:indexPath];
    }
}

#pragma mark - SOLoginCell Delegate
-(void)loginCellLoginClick:(SOLoginCell *)cell{
    [self enterLogin];
}
#pragma mark - SOLogoutCell Delegate
-(void)logoutCellLogoutClick:(SOLogoutCell *)cell{
    [[SOManager manager]logout];
    [self.tableView reloadData];
}
#pragma mark - SOUserInfoCell Delegate
-(void)userInfoCellTapQRCodeImage:(SOUserInfoCell *)cell{
    [self requestMyQRCode];
}
#pragma mark - SOScanViewController Delegate
-(void)scanViewController:(SOScanViewController *)vc sannerQRCode:(NSString *)result{
    if (result.length>0) {
        NSDictionary *lDic=@{@"qr_code":result,@"user_id":[SOManager manager].user.student_id};
        [self sannerQRCodeWith:lDic];
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:USER_INFO_CELL_ID bundle:nil] forCellReuseIdentifier:USER_INFO_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:LOGIN_CELL_ID bundle:nil] forCellReuseIdentifier:LOGIN_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:USER_SELECT_CELL_ID bundle:nil] forCellReuseIdentifier:USER_SELECT_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:LOGOUT_CELL_ID bundle:nil] forCellReuseIdentifier:LOGOUT_CELL_ID];
}
-(void)configureData{
    NSString *lPath=[[NSBundle mainBundle]pathForResource:@"userHome" ofType:@"json"];
    NSData *lData=[NSData dataWithContentsOfFile:lPath];
    self.infoArray=[NSJSONSerialization JSONObjectWithData:lData options:NSJSONReadingAllowFragments error:nil];
}
#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Network Request
-(void)requestMyQRCode{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork getWithProtocol:GET_QRCODE_PROTOCOL([SOManager manager].user.student_id) andParam:nil success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        SOQRCodeShowView *lView=[[SOQRCodeShowView alloc]initWithQRImage:[QRCScanner scQRCodeForString:data size:QR_CODE_IMAGE_SIDE]];
        [lView show];
        
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)sannerQRCodeWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:SCAN_QRCODE_PROTOCOL andParam:param andProtocolID:SCAN_QRCODE_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD show:@"等待教练确认" view:self.view];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
