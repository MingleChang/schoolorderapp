//
//  SOApplyViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOApplyViewController.h"
#import "SONetwork.h"
#import "MBProgressHUD+HUDSHOW.h"

@interface SOApplyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *schoolImage;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *schoolPhone;
@property (weak, nonatomic) IBOutlet UILabel *schoolAdress;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *phoneInptu;
@property (weak, nonatomic) IBOutlet UITextField *remarkInput;

@end

@implementation SOApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"报名";
    [self configuration];
}

-(void)configuration{
    [self.schoolImage setImageWithURL:[NSURL URLWithString:self.schoolModel.imgUrl] placeholderImage:DefaultImage];
    self.schoolName.text = [NSString stringWithFormat:@"驾校:%@",self.schoolModel.schoolName];
    self.schoolPhone.text = [NSString stringWithFormat:@"电话:%@",self.schoolModel.tel];
    self.schoolAdress.text = [NSString stringWithFormat:@"地址:%@",self.schoolModel.schoolAddr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyAction:(id)sender {
    if (self.nameInput.text.length==0) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入姓名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.phoneInptu.text.length==0) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSPredicate *lPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES '^(0|86|17951)?(13[0-9]|15[0-9]|17[0678]|18[0-9]|14[57])[0-9]{8}$'"];
    if (![lPredicate evaluateWithObject:self.phoneInptu.text]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *item = @{@"school_id":self.schoolModel.school_id,@"schoolName":self.schoolModel.schoolName,@"studentName":self.nameInput.text,@"phone":self.phoneInptu.text,@"remark":self.remarkInput.text};
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork postWithProtocol:SCHOOL_APPLY andParam:item andProtocolID:@"STUDENTORDERENTRY" success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD show:@"报名成功" view:[MCDevice getAppFrontWindow]];
        self.nameInput.text = @"";
        self.phoneInptu.text = @"";
        self.remarkInput.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

@end
