//
//  SOForgetViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOForgetViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SONetwork.h"

@interface SOForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
- (IBAction)submitButtonClick:(UIButton *)sender;

@end

@implementation SOForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
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
- (IBAction)submitButtonClick:(UIButton *)sender {
    [self.passwordText resignFirstResponder];
    [self.confirmText resignFirstResponder];
    NSString *lPassword=[self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lConfirm=[self.confirmText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self checkPassword:lPassword andConfirm:lConfirm]) {
        return;
    }
    NSDictionary *lParam=@{@"phone":self.verificationCode.phone,@"verification":self.verificationCode.verification,@"ver_no":self.verificationCode.ver_no,@"passwd":lPassword};
    [self forgetWith:lParam];
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
    self.title=@"设置密码";
}

#pragma mark - Network Request
-(void)forgetWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:FORGET_PROTOCOL andParam:param andProtocolID:FORGET_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD show:@"设置密码成功" view:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
