//
//  SOChangePwdViewController.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOChangePwdViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SONetwork.h"

@interface SOChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
- (IBAction)submitButtonClick:(UIButton *)sender;

@end

@implementation SOChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(BOOL)checkOldPassword:(NSString *)oldPassword andPassword:(NSString *)password andConfirm:(NSString *)confirm{
    if (oldPassword.length==0) {
        [MBProgressHUD show:@"请输入原密码" icon:nil view:self.view];
        return NO;
    }
    if (password.length==0) {
        [MBProgressHUD show:@"请输入新密码" icon:nil view:self.view];
        return NO;
    }
    if (confirm.length==0) {
        [MBProgressHUD show:@"请确认新密码" icon:nil view:self.view];
        return NO;
    }
    if (![password isEqualToString:confirm]) {
        [MBProgressHUD show:@"两次密码不一致" icon:nil view:self.view];
        return NO;
    }
    return YES;
}
#pragma mark - Event Response
- (IBAction)submitButtonClick:(UIButton *)sender {
    NSString *lOldPassword=[self.oldPasswordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lPassword=[self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lConfirm=[self.confirmText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self checkOldPassword:lOldPassword andPassword:lPassword andConfirm:lConfirm]) {
        return;
    }
    NSDictionary *lParam=@{@"user_id":[SOManager manager].user.student_id,@"old_pass":lOldPassword,@"new_pass":lPassword};
    [self changePasswordWith:lParam];
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
    self.oldPasswordText.layer.borderColor=[UIColor grayColor].CGColor;
    self.oldPasswordText.layer.borderWidth=ONE_PIXEL;
    self.oldPasswordText.layer.cornerRadius=4;
    
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
    self.title=@"安安学车";
}
#pragma mark - Network Request
-(void)changePasswordWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:CHANGE_PASSWORD_PROTOCOL andParam:param andProtocolID:CHANGE_PASSWORD_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *lDic=[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_USER_LOGIN];
        lDic=@{@"userid":lDic[@"userid"],@"password":param[@"new_pass"]};
        [[NSUserDefaults standardUserDefaults]setObject:lDic forKey:USERDEFAULT_USER_LOGIN];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [MBProgressHUD show:@"修改密码成功" view:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
