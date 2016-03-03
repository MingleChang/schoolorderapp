//
//  SoMyAccountsViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMyAccountsViewController.h"
#import "SOPayRecordViewController.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SONetwork.h"
#import "SOAccount.h"
#import <Masonry/Masonry.h>

@interface SOMyAccountsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property(nonatomic,strong)SOPayRecordViewController *allVC;
@property(nonatomic,strong)SOPayRecordViewController *payVC;

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender;
@end

@implementation SOMyAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)setSubViewConstroller{
    self.allVC=[[SOPayRecordViewController alloc]init];
    self.allVC.type=1;
    [self.allView addSubview:self.allVC.view];
    [self addChildViewController:self.allVC];
    [self.allVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.allView);
    }];
    
    self.payVC=[[SOPayRecordViewController alloc]init];
    self.payVC.type=2;
    [self.payView addSubview:self.payVC.view];
    [self addChildViewController:self.payVC];
    [self.payVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.payView);
    }];
}
#pragma mark - Event Response

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*sender.selectedSegmentIndex, 0) animated:YES];
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
    self.lineHeightConstraint.constant=ONE_PIXEL;
    self.nameLabel.text=[NSString stringWithFormat:@"学生姓名：%@",[SOManager manager].user.name];
    self.modelLabel.text=[NSString stringWithFormat:@"计费模式：%@",[SOManager manager].user.cost_type];
    [self setSubViewConstroller];
}
-(void)configureData{
    [self updateAccount];
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
    self.title=@"我的账户";
}

#pragma mark - Network Request
-(void)updateAccount{
    [SONetwork getWithProtocol:ACCOUNT_PROTOCOL andParam:nil success:^(id data) {
        SOAccount *lAccount=[SOAccount mj_objectWithKeyValues:data];
        self.nowMoneyLabel.text=[NSString stringWithFormat:@"当前余额：%0.2f元",lAccount.available_money.doubleValue];
        self.totalMoneyLabel.text=[NSString stringWithFormat:@"累计余额：%0.2f元",lAccount.use_money.doubleValue];
    } failed:^{
        
    }];
}
@end
