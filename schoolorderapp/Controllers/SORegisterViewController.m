//
//  SORegisterViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SORegisterViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SONetwork.h"

@interface SORegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *identityText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
- (IBAction)createButtonClick:(UIButton *)sender;

@end

@implementation SORegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
#pragma mark - Check
-(BOOL)checkIdentity:(NSString *)identity{
    if (identity.length==0) {
        [MBProgressHUD show:@"请输入身份证" icon:nil view:self.view];
        return NO;
    }
    return YES;
}
-(BOOL)checkName:(NSString *)name{
    if (name.length==0) {
        [MBProgressHUD show:@"请输入姓名" icon:nil view:self.view];
        return NO;
    }
    return YES;
}
-(BOOL)checkPassword:(NSString *)password andConfirm:(NSString *)confirm{
    if (password.length==0) {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view];
        return NO;
    }
    if (confirm.length==0) {
        [MBProgressHUD show:@"请确认密码" icon:nil view:self.view];
        return NO;
    }
    if (![password isEqualToString:confirm]) {
        [MBProgressHUD show:@"两次密码不一致" icon:nil view:self.view];
        return NO;
    }
    return YES;
}
#pragma mark - Event Response
- (IBAction)createButtonClick:(UIButton *)sender {
    NSString *lIdentity=[self.identityText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lName=[self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lPassword=[self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lConfirm=[self.confirmText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self checkIdentity:lIdentity]) {
        return;
    }
    if (![self checkName:lName]) {
        return;
    }
    if (![self checkPassword:lPassword andConfirm:lConfirm]) {
        return;
    }
    NSDictionary *lParam=@{@"phone":self.verificationCode.phone,@"idcard":lIdentity,@"name":lName,@"verification":self.verificationCode.verification,@"ver_no":self.verificationCode.ver_no,@"passwd":lPassword};
    [self registerWith:lParam];
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
    self.identityText.layer.borderColor=[UIColor grayColor].CGColor;
    self.identityText.layer.borderWidth=ONE_PIXEL;
    self.identityText.layer.cornerRadius=4;
    
    self.nameText.layer.borderColor=[UIColor grayColor].CGColor;
    self.nameText.layer.borderWidth=ONE_PIXEL;
    self.nameText.layer.cornerRadius=4;
    
    self.passwordText.layer.borderColor=[UIColor grayColor].CGColor;
    self.passwordText.layer.borderWidth=ONE_PIXEL;
    self.passwordText.layer.cornerRadius=4;
    
    self.confirmText.layer.borderColor=[UIColor grayColor].CGColor;
    self.confirmText.layer.borderWidth=ONE_PIXEL;
    self.confirmText.layer.cornerRadius=4;
}

-(void)configureData{
    
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
    self.title=@"创建用户";
}

#pragma mark - Network Request
-(void)registerWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:REGISTER_PROTOCOL andParam:param andProtocolID:REGISTER_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD show:@"注册成功" view:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
