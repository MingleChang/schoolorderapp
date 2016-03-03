//
//  SOLoginViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOLoginViewController.h"
#import "SONetwork.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOSMSViewController.h"

@interface SOLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

- (IBAction)loginButtonClick:(UIButton *)sender;
- (IBAction)visitorButtonClick:(UIButton *)sender;
- (IBAction)forgetButtonClick:(UIButton *)sender;
- (IBAction)registerButtonClick:(UIButton *)sender;

@end

@implementation SOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)backToLastVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Event Response
- (IBAction)loginButtonClick:(UIButton *)sender {
    [self.telephoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    NSString *lTelephone=[self.telephoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lPassword=[self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self loginWith:@{@"userid":lTelephone?lTelephone:@"",@"password":lPassword?lPassword:@""}];
}

- (IBAction)visitorButtonClick:(UIButton *)sender {
    [self backToLastVC];
}

- (IBAction)forgetButtonClick:(UIButton *)sender {
    SOSMSViewController *lViewController=[[SOSMSViewController alloc]init];
    lViewController.type=SMSTypeForget;
    [self.navigationController pushViewController:lViewController animated:YES];
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    SOSMSViewController *lViewController=[[SOSMSViewController alloc]init];
    lViewController.type=SMSTypeRegister;
    [self.navigationController pushViewController:lViewController animated:YES];
}

#pragma mark - Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor=GREEN_COLOR.CGColor;
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor=[UIColor grayColor].CGColor;
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
    self.telephoneText.layer.borderColor=[UIColor grayColor].CGColor;
    self.telephoneText.layer.borderWidth=ONE_PIXEL;
    self.telephoneText.layer.cornerRadius=4;
    self.passwordText.layer.borderColor=[UIColor grayColor].CGColor;
    self.passwordText.layer.borderWidth=ONE_PIXEL;
    self.passwordText.layer.cornerRadius=4;
}
-(void)configureData{
    
}

#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)resetNavigationBarItems{
    [super resetNavigationBarItems];
    self.title=@"登录";
}


#pragma mark - Network Request
-(void)loginWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:LOGIN_PROTOCOL andParam:param andProtocolID:LOGIN_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        SOUser *lUser=[SOUser mj_objectWithKeyValues:data];
        [SOManager manager].user=lUser;
        [[NSUserDefaults standardUserDefaults]setObject:param forKey:USERDEFAULT_USER_LOGIN];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self backToLastVC];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
