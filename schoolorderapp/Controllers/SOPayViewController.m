//
//  SOPayViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPayViewController.h"
#import "SOPayBankTableViewCell.h"
#import "SOPayInforTableViewCell.h"
#import "SOPayBtnTableViewCell.h"
#import "SONetwork.h"
#import "SOPayOrder.h"
#import "SOAccount.h"
#import "SOPayMethod.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOCallPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
#import "SOPayHintCell.h"

#define PAY_INFO_CELL_ID @"SOPayInforTableViewCell"
#define PAY_BANK_CELL_ID @"SOPayBankTableViewCell"
#define PAY_BTN_CELL_ID @"SOPayBtnTableViewCell"
#define PAY_HINT_CELL_ID @"SOPayHintCell"

@interface SOPayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSArray *payInforTitles;
@property(nonatomic,copy)NSArray *payMethodArray;

@property(nonatomic,strong)SOPayMethod *selectedMethod;

@property(nonatomic,strong)SOPayOrder *payOrder;
@property(nonatomic,strong)SOAccount *account;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end

@implementation SOPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)resetTableViewInfo{
    NSString *lPath=[[NSBundle mainBundle]pathForResource:@"payMethod" ofType:@"json"];
    NSData *lData=[NSData dataWithContentsOfFile:lPath];
    self.payMethodArray=[SOPayMethod mj_objectArrayWithKeyValuesArray:lData];
    if (self.account.available_money.doubleValue<self.payOrder.total_fee.doubleValue) {
        self.payMethodArray=[self.payMethodArray subarrayWithRange:NSMakeRange(1, self.payMethodArray.count-1)];
    }
    self.selectedMethod=self.payMethodArray.firstObject;
    [self.mainTable reloadData];
}

#pragma mark - Delegate
#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.payOrder) {
        return 3;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.payInforTitles.count;
    }else if (section==1){
        return self.payMethodArray.count;
    }else{
        return self.selectedMethod?2:0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    if (indexPath.section == 0) {
        
        SOPayInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAY_INFO_CELL_ID forIndexPath:indexPath];
        [cell setCellTitleLabWithDic:self.payInforTitles[indexPath.row]];
        if (row==0) {
            [cell setCellContentLabWithObj:self.payOrder.subject];
        }else if (row==1){
            [cell setCellContentLabWithObj:self.payOrder.total_fee.stringValue];
        }else{
            [cell setCellContentLabWithObj:self.account.available_money.stringValue];
        }
        return cell;
    }else if (indexPath.section == 1){
        SOPayBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAY_BANK_CELL_ID forIndexPath:indexPath];
        SOPayMethod *lPayMethod=self.payMethodArray[row];
        if (lPayMethod.payType==self.selectedMethod.payType) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        cell.payMethod=lPayMethod;
        return cell;
    }else{
        if (row==0) {
            SOPayBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAY_BTN_CELL_ID forIndexPath:indexPath];
            return cell;
        }else{
            SOPayHintCell *cell=[tableView dequeueReusableCellWithIdentifier:PAY_HINT_CELL_ID forIndexPath:indexPath];
            return cell;
        }
    }
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 60;
    }else{
        return 48;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    if (section==1) {
        self.selectedMethod=self.payMethodArray[row];
        [self.mainTable reloadData];
    }else if (section==2){
        if (self.selectedMethod==nil) {
            return;
        }
        [self requestPay];
    }
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    [self.mainTable registerNib:[UINib nibWithNibName:PAY_INFO_CELL_ID bundle:nil] forCellReuseIdentifier:PAY_INFO_CELL_ID];
    [self.mainTable registerNib:[UINib nibWithNibName:PAY_BANK_CELL_ID bundle:nil] forCellReuseIdentifier:PAY_BANK_CELL_ID];
    [self.mainTable registerNib:[UINib nibWithNibName:PAY_BTN_CELL_ID bundle:nil] forCellReuseIdentifier:PAY_BTN_CELL_ID];
    [self.mainTable registerNib:[UINib nibWithNibName:PAY_HINT_CELL_ID bundle:nil] forCellReuseIdentifier:PAY_HINT_CELL_ID];
}
-(void)configureData{
    self.payInforTitles = @[@{@"title":@"订单名称:"},@{@"title":@"订单金额:"},@{@"title":@"账户余额:"}];
    [self requestOrderInfo];
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
    self.title=@"支付";
}
#pragma mark - Network Request
-(void)requestOrderInfo{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork getWithProtocol:GET_ORDER_INFO_PROTOCOL(self.orderId) andParam:nil success:^(id data) {
        self.payOrder=[SOPayOrder mj_objectWithKeyValues:data];
        [self updateAccountWithSchoolId:self.payOrder.school_id];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)updateAccountWithSchoolId:(NSString *)schoolId{
    [SONetwork getWithProtocol:GET_ACCOUNT_PROTOCOL(schoolId) andParam:nil success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        self.account=[SOAccount mj_objectWithKeyValues:data];
        [self resetTableViewInfo];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)requestPay{
    NSDictionary *lDic=nil;
    if (self.selectedMethod.payType==SOPayMethodTypeAccount) {
        lDic=@{@"order_id":self.orderId,@"pay_method":self.selectedMethod.payMethod,@"account_pay":self.payOrder.total_fee};
    }else{
        lDic=@{@"order_id":self.orderId,@"pay_method":self.selectedMethod.payMethod,@"online_pay":self.payOrder.total_fee};
    }
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:PAY_PROTOCOL andParam:lDic andProtocolID:PAY_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        SOCallPay *lCallPay=[SOCallPay mj_objectWithKeyValues:data];
        lCallPay.pay_method=self.selectedMethod.payMethod;
        [SOManager manager].callPay=lCallPay;
        [[SOManager manager]setPaySuccessBlock:^(id data){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        switch (self.selectedMethod.payType) {
            case SOPayMethodTypeAccount:
                [self accountWithInfo:lCallPay];
                break;
            case SOPayMethodTypeUnionpay:
                [self unionpayWithInfo:lCallPay];
                break;
            case SOPayMethodTypeAlipay:
                [self alipayWithInfo:lCallPay];
                break;
            default:
                break;
        }
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)accountWithInfo:(SOCallPay *)callPay{
    [MBProgressHUD show:@"支付成功" view:[UIApplication sharedApplication].keyWindow];
    [SOManager manager].callPay=nil;
    [SOManager manager].paySuccessBlock(nil);
    [SOManager manager].paySuccessBlock=nil;
}
-(void)unionpayWithInfo:(SOCallPay *)callPay{
    [[UPPaymentControl defaultControl]startPay:callPay.pay_info fromScheme:UNIONPAY_SCHEMES mode:@"00" viewController:self];
}
-(void)alipayWithInfo:(SOCallPay *)callPay{
    [[AlipaySDK defaultService]payOrder:callPay.pay_info fromScheme:ALIPAY_SCHEMES callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            [MBProgressHUD show:@"支付成功" view:[UIApplication sharedApplication].keyWindow];
            [[SOManager manager]payCallBackWith:0];
            [SOManager manager].paySuccessBlock(nil);
            [SOManager manager].paySuccessBlock=nil;
        }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
            [MBProgressHUD show:@"支付取消" view:[UIApplication sharedApplication].keyWindow];
            [[SOManager manager]payCallBackWith:2];
        }else{
            [MBProgressHUD show:@"支付失败" view:[UIApplication sharedApplication].keyWindow];
            [[SOManager manager]payCallBackWith:1];
        }
    }];
}
@end
