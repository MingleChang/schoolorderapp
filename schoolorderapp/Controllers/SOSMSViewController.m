//
//  SOSMSViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/8.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSMSViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SONetwork.h"
#import "SOVerificationCode.h"
#import "SOForgetViewController.h"
#import "SORegisterViewController.h"

@interface SOSMSViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeText;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property(nonatomic,strong)SOVerificationCode *verificationCode;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger timerCount;

- (IBAction)verificationButtonClick:(UIButton *)sender;
- (IBAction)submitButtonClick:(UIButton *)sender;

@end

@implementation SOSMSViewController

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
-(BOOL)checkPhoneNumber:(NSString *)number{
    if (number.length==0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return NO;
    }
    NSPredicate *lPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES '^(0|86|17951)?(13[0-9]|15[0-9]|17[0678]|18[0-9]|14[57])[0-9]{8}$'"];
    if (![lPredicate evaluateWithObject:number]) {
        [MBProgressHUD show:@"手机号格式错误" icon:nil view:self.view];
        return NO;
    }
    return YES;
}

-(BOOL)checkPhoneNumber:(NSString *)number andVerificationCode:(NSString *)verificationCode{
    if (![self checkPhoneNumber:number]) {
        return NO;
    }
    if (verificationCode.length==0) {
        [MBProgressHUD show:@"请输入验证码" icon:nil view:self.view];
        return NO;
    }
    if (!([number isEqualToString:self.verificationCode.phone]&&[verificationCode isEqualToString:self.verificationCode.verification])) {
        [MBProgressHUD show:@"无效验证码" icon:nil view:self.view];
        return NO;
    }
    return YES;
}

#pragma mark - Timer Update
-(void)verificationTimeUpdate:(NSTimer *)sender{
    self.timerCount=self.timerCount-1;
    [self.verificationButton setTitle:[NSString stringWithFormat:@"%i秒后重试",(int)self.timerCount] forState:UIControlStateDisabled];
    if (self.timerCount==0) {
        [self setVerificationButtonEnabled:YES];
        [self.timer invalidate];
    }
}
#pragma mark - Reset Verification Button
-(void)setVerificationButtonEnabled:(BOOL)enable{
    self.verificationButton.enabled=enable;
    if (enable) {
        self.verificationButton.layer.borderColor=GREEN_COLOR.CGColor;
        self.verificationButton.layer.borderWidth=1;
        self.verificationButton.layer.cornerRadius=4;
        self.verificationButton.backgroundColor=[UIColor whiteColor];
    }else{
        [self.verificationButton setTitle:[NSString stringWithFormat:@"%i秒后重试",(int)self.timerCount] forState:UIControlStateDisabled];
        self.verificationButton.layer.borderColor=[UIColor clearColor].CGColor;
        self.verificationButton.layer.borderWidth=0;
        self.verificationButton.layer.cornerRadius=4;
        self.verificationButton.backgroundColor=[UIColor lightGrayColor];
    }
}
#pragma mark - Enter Next VC
-(void)enterNextViewController{
    switch (self.type) {
        case SMSTypeForget:{
            SOForgetViewController *lViewController=[[SOForgetViewController alloc]init];
            lViewController.verificationCode=self.verificationCode;
            [self.navigationController pushViewController:lViewController animated:YES];
        }break;
        case SMSTypeRegister:{
            SORegisterViewController *lViewController=[[SORegisterViewController alloc]init];
            lViewController.verificationCode=self.verificationCode;
            [self.navigationController pushViewController:lViewController animated:YES];
        }break;
        case SMSTypeSign:{
            
        }break;
        case SMSTypeSignout:{
            
        }break;
        default:
            break;
    }
}
#pragma mark - Event Response
- (IBAction)verificationButtonClick:(UIButton *)sender {
    [self.telephoneText resignFirstResponder];
    [self.verificationCodeText resignFirstResponder];
    NSString *lTelephone=[self.telephoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self checkPhoneNumber:lTelephone]) {
        return;
    }
    [self sendSMSWith:@{@"phone":lTelephone,@"type":@(self.type),@"receive_type":@(2)}];
    
}

- (IBAction)submitButtonClick:(UIButton *)sender {
    [self.telephoneText resignFirstResponder];
    [self.verificationCodeText resignFirstResponder];
    NSString *lTelephone=[self.telephoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lVerificationCode=[self.verificationCodeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self checkPhoneNumber:lTelephone andVerificationCode:lVerificationCode]) {
        [self validateVerificationCodeWith:self.verificationCode.mj_JSONObject];
    }
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
    self.verificationCodeText.layer.borderColor=[UIColor grayColor].CGColor;
    self.verificationCodeText.layer.borderWidth=ONE_PIXEL;
    self.verificationCodeText.layer.cornerRadius=4;
    self.verificationButton.layer.borderColor=GREEN_COLOR.CGColor;
    self.verificationButton.layer.borderWidth=1;
    self.verificationButton.layer.cornerRadius=4;
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
    self.title=@"短信验证";
}

#pragma mark - Network Request
-(void)sendSMSWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:SMS_PROTOCOL andParam:param andProtocolID:SMS_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        MCLOG(@"%@",data);
        self.verificationCode=[SOVerificationCode mj_objectWithKeyValues:data];
        self.submitButton.hidden=NO;
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verificationTimeUpdate:) userInfo:nil repeats:YES];
        self.timerCount=60;
        [self setVerificationButtonEnabled:NO];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)validateVerificationCodeWith:(NSDictionary *)param{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:SMS_VALIDATE_PROTOCOL andParam:param andProtocolID:SMS_VALIDATE_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [self enterNextViewController];
        
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
